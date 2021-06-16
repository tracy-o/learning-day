defmodule Belfrage.Metrics.MailboxMonitorTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Metrics.MailboxMonitor
  alias Belfrage.TestGenServer
  alias Belfrage.{Loop, LoopsSupervisor}

  setup do
    start_supervised!({TestGenServer, name: :test_server_one}, id: :test_server_one)
    start_supervised!({TestGenServer, name: :test_server_two}, id: :test_server_two)
    start_supervised!(LoopsSupervisor.child_spec(name: :test_loop_supervisor, id: :test_loop_supervisor))
    :ok
  end

  defp increase_loop(loop_name) do
    {:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, loop_name}}}
    |> GenServer.cast({:inc, 200, "MyOrigin", true})
  end

  describe "handle_info/2 with generic processes" do
    test "reports the mailbox size of zero when the mailbox is empty" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.test_server_one.mailbox_size", value: 0 -> true end)

      assert {:noreply, %{servers: [:test_server_one]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [:test_server_one]})
    end

    test "reports the mailbox size when the mailbox is not empty" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.test_server_one.mailbox_size", value: 2 -> true end)

      ref = make_ref()

      TestGenServer.work(:test_server_one, {:work, self(), ref})
      TestGenServer.work(:test_server_one)
      TestGenServer.work(:test_server_one)

      assert_receive {:work, ref}

      assert {:noreply, %{servers: [:test_server_one]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [:test_server_one]})
    end

    test "reports the mailbox size for more than one server" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.test_server_one.mailbox_size", value: 2 -> true end)
      |> expect(:record, fn :metric, :gauge, "gen_server.test_server_two.mailbox_size", value: 3 -> true end)

      ref_one = make_ref()
      ref_two = make_ref()

      TestGenServer.work(:test_server_one, {:work, self(), ref_one})
      TestGenServer.work(:test_server_one)
      TestGenServer.work(:test_server_one)

      TestGenServer.work(:test_server_two, {:work, self(), ref_two})
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)

      assert_receive {:work, ref}
      assert_receive {:work, ref_two}

      assert {:noreply, %{servers: [:test_server_one, :test_server_two]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [:test_server_one, :test_server_two]})
    end

    test "does not report when the gen_server is not running" do
      Belfrage.EventMock
      |> expect(:record, 0, fn :metric, :gauge, _name, _opts -> true end)

      assert {:noreply, %{servers: [:missing_server]}} =
               MailboxMonitor.handle_info(:refresh, %{servers: [:missing_server]})
    end

    test "logs an info message when the gen_server is not running" do
      Belfrage.EventMock
      |> expect(:record, fn :log,
                            :info,
                            %{msg: "Error retrieving the mailbox size for missing_server, pid could not be found"} ->
        true
      end)

      assert {:noreply, %{servers: [:missing_server]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [:missing_server]})
    end
  end

  describe "handle_info/2 with loops" do
    test "reports the mailbox size of zero when a loop has just started" do
      LoopsSupervisor.start_loop(:test_loop_supervisor, "HomePage")

      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "loop.HomePage.mailbox_size", value: 0 -> true end)

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [{:loop, "HomePage"}]})
    end

    test "reports the mailbox size when a loop has received a call" do
      LoopsSupervisor.start_loop(:test_loop_supervisor, "HomePage")

      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "loop.HomePage.mailbox_size", value: 1 -> true end)

      increase_loop("HomePage")

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [{:loop, "HomePage"}]})
    end

    test "does not report when the loop is not running" do
      Belfrage.EventMock
      |> expect(:record, 0, fn :metric, :gauge, _name, _opts -> true end)

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} =
               MailboxMonitor.handle_info(:refresh, %{servers: [{:loop, "HomePage"}]})
    end

    test "logs an info message if a loop has not started" do
      Belfrage.EventMock
      |> expect(:record, fn :log,
                            :info,
                            %{msg: "Error retrieving the mailbox size for loop HomePage, pid could not be found"} ->
        true
      end)

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [{:loop, "HomePage"}]})
    end
  end
end
