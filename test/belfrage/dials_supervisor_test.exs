defmodule Belfrage.DialsSupervisorTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  import Belfrage.DialsSupervisor
  import Fixtures.Dials

  @dials_supervisor Belfrage.DialsSupervisor
  @dials_poller Belfrage.Dials.Poller

  test "dials supervisor is alive" do
    assert Process.whereis(@dials_supervisor) |> Process.alive?()
  end

  test "dial_config/0 returns expected dials data" do
    expected_dials_data =
      Application.get_env(:belfrage, :dial_handlers)
      |> Enum.map(fn {name, module} ->
        default = Enum.find(cosmos_dials_data(), fn dial -> dial["name"] == name end)["default-value"]
        {module, String.to_atom(name), default}
      end)

    assert expected_dials_data == dial_config()
  end

  test "dials poller is running as part of the dials supervision tree" do
    children = Supervisor.which_children(@dials_supervisor) |> Enum.map(&elem(&1, 0))
    assert @dials_poller in children
  end

  test "dials are running as part of the dials supervision tree" do
    children =
      Supervisor.which_children(@dials_supervisor)
      |> Enum.map(&elem(&1, 0))

    for {_module, name, _default} <- dial_config() do
      assert name in children
    end
  end

  Enum.each(dial_config(), fn {module, name, default} ->
    @name name
    @module module
    @default default
    @test_dial :"test_#{to_string(name)}"

    describe "when #{@name} dial crashes" do
      setup do
        start_supervised({Belfrage.Dial, {@module, @test_dial, @default}})
        :ok
      end

      test "it should restart" do
        pid = Process.whereis(@test_dial)
        Process.exit(pid, :kill)
        Process.sleep(10)

        new_pid = Process.whereis(@test_dial)

        refute is_nil(new_pid)
        refute new_pid == pid, "Dial did not crash, so this test is invalid."
      end

      test "it should log error" do
        assert capture_log(fn ->
                 GenServer.cast(@test_dial, {:dials_changed, %{to_string(@test_dial) => "this crashes the dial"}})
                 :timer.sleep(50)
               end) =~ "terminating\n** (FunctionClauseError) no function clause matching"
      end

      test "it should restart with default state" do
        Process.whereis(@test_dial) |> Process.exit(:kill)
        Process.sleep(10)

        expected_default = apply(@module, :transform, [@default])
        assert expected_default == :sys.get_state(@test_dial) |> elem(2)
      end
    end
  end)

  test "notifies dials of new dial data" do
    dials_data = %{
      "circuit_breaker" => "false"
    }

    Belfrage.DialsSupervisor.notify(:dials_changed, dials_data)

    assert false == Belfrage.Dial.state(:circuit_breaker)
  end
end
