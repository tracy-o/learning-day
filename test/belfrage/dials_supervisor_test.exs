defmodule Belfrage.DialsSupervisorTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Belfrage.DialsSupervisor
  import Fixtures.Dials

  @dials_poller Belfrage.Dials.Poller
  @dials_supervisor Belfrage.DialsSupervisor

  test "dials supervisor is alive" do
    assert Process.whereis(@dials_supervisor) |> Process.alive?()
  end

  test "dial_config/0 returns dials config data in {module, atom name, default value} tuple format" do
    dial_handlers_config = Application.get_env(:belfrage, :dial_handlers)

    cosmos_file_defaults =
      for {name, module} <- dial_handlers_config do
        {module, Enum.find(cosmos_dials_data(), fn dial -> dial["name"] == name end)["default-value"]}
      end

    expected_data =
      for {name, module} <- dial_handlers_config do
        {module, String.to_atom(name), cosmos_file_defaults[module]}
      end

    assert expected_data == dial_config()
  end

  test "dials poller is running as part of the dials supervision tree" do
    assert @dials_poller in (Supervisor.which_children(@dials_supervisor) |> Enum.map(&elem(&1, 0)))
  end

  test "dials are running as part of the dials supervision tree" do
    for {_module, name, _default} <- dial_config() do
      assert name in (Supervisor.which_children(@dials_supervisor) |> Enum.map(&elem(&1, 0)))
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

  describe "when dials changed, dials supervisor notifies" do
    Enum.each(dial_config(), fn {module, name, default} ->
      @name name
      @module module
      @default default

      test "#{@name} dial of new dial value" do
        new_state_value = other_dial_state(to_string(@name), @default)
        new_state = apply(@module, :transform, [new_state_value])
        current_state = Belfrage.Dial.state(@name)

        Belfrage.DialsSupervisor.notify(:dials_changed, %{to_string(@name) => new_state_value})

        assert new_state != current_state
        assert new_state == Belfrage.Dial.state(@name)
      end
    end)
  end
end
