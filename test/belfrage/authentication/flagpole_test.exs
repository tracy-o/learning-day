defmodule Belfrage.Authentication.FlagpoleTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog

  alias Belfrage.Authentication.Flagpole
  alias Belfrage.Clients.AccountMock

  @server :flagpole_test

  setup do
    {:ok, _pid} = start_supervised(%{id: @server, start: {Flagpole, :start_link, [[name: @server]]}})
    :ok
  end

  test "state/1 returns boolean state" do
    assert is_boolean(Flagpole.state(@server))
  end

  describe "poll/1" do
    test "triggers account client call for IDCTA config" do
      AccountMock |> expect(:get_idcta_config, fn -> {:ok, %{"id-availability" => "GREEN"}} end)
      Flagpole.poll(@server)
      Process.sleep(10)
    end

    test "fetches new state" do
      AccountMock |> expect(:get_idcta_config, fn -> {:ok, %{"id-availability" => "GREEN"}} end)
      Flagpole.poll(@server)
      current_state = Flagpole.state(@server)
      assert current_state == true

      AccountMock |> expect(:get_idcta_config, fn -> {:ok, %{"id-availability" => "RED"}} end)
      Flagpole.poll(@server)
      new_state = Flagpole.state(@server)
      assert new_state == false
    end

    test "handles unknown state and fallbacks to current state" do
      current_state = Flagpole.state(@server)
      AccountMock |> expect(:get_idcta_config, fn -> {:ok, %{"id-availability" => "BLUE"}} end)
      Flagpole.poll(@server)

      new_state = Flagpole.state(@server)
      assert current_state == new_state
    end
  end

  describe "GenServer" do
    test "default state is true" do
      assert Flagpole.state(@server) == true
    end

    test "restart with default state after crash" do
      previous_pid = Process.whereis(@server)
      Process.exit(previous_pid, :kill)

      refute Process.alive?(previous_pid)
      Process.sleep(30)

      new_pid = Process.whereis(@server)
      assert Process.alive?(new_pid)
      refute previous_pid == new_pid

      assert Flagpole.state(@server) == true
    end

    test "polling happens as scheduled" do
      # restart GenServer with 20ms poll rate for test
      :ok = stop_supervised(@server)
      {:ok, _pid} = start_supervised({Flagpole, [name: @server, poll_rate: 20]})

      assert Flagpole.state(@server) == true

      # wait for polling, the RED state from stub
      Process.sleep(50)
      assert Flagpole.state(@server) == false
    end

    test "handle_info/2 handles unknown state" do
      state = {10_000, true}
      AccountMock |> expect(:get_idcta_config, fn -> {:ok, %{"id-availability" => "BLUE"}} end)
      assert capture_log(fn -> Flagpole.handle_info(:poll, state) end) =~ "Unknown state: BLUE"
    end

    test "handle_info/2 handles unavailable state" do
      state = {10_000, true}
      AccountMock |> expect(:get_idcta_config, fn -> {:ok, %{}} end)
      assert capture_log(fn -> Flagpole.handle_info(:poll, state) end) =~ "idcta state unavailable in config"
    end

    test "handle_info/2 handles malformed state" do
      state = {10_000, true}
      AccountMock |> expect(:get_idcta_config, fn -> {:ok, "malformed idcta config"} end)
      assert capture_log(fn -> Flagpole.handle_info(:poll, state) end) =~ "idcta state unavailable in config"
    end
  end
end
