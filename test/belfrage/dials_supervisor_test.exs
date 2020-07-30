defmodule Belfrage.DialsSupervisorTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  import Belfrage.DialsSupervisor

  @dials_supervisor Belfrage.DialsSupervisor
  @dials_poller Belfrage.Dials.Poller

  defp expected_dial_default(dial_name) do
    Enum.find_value(dial_config(), fn
      {dial_mod, ^dial_name, default_value} ->
        apply(dial_mod, :transform, [default_value])

      _other ->
        nil
    end)
  end

  test "dials supervisor is alive" do
    assert Process.whereis(@dials_supervisor) |> Process.alive?()
  end

  test "dial_config/0 returns expected dials data" do
    dials_json =
      Application.app_dir(:belfrage, "priv/static/dials.json")
      |> File.read!()
      |> Jason.decode!()

    expected_dials_data =
      Application.get_env(:belfrage, :dial_handlers)
      |> Enum.map(fn {name, module} ->
        default = Enum.find(dials_json, fn dial -> dial["name"] == name end)["default-value"]
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

  test "when dial crashes, error is logged and dial is restarted with default state" do
    supervised_dial = Belfrage.Dials.CircuitBreaker
    pid = Process.whereis(supervised_dial)
    expected_default_value = expected_dial_default(:circuit_breaker)

    assert capture_log(fn ->
             GenServer.cast(:circuit_breaker, {:dials_changed, %{"circuit_breaker" => "bar"}})
             :timer.sleep(100)
           end) =~ "no function clause matching"

    new_pid = GenServer.whereis(:circuit_breaker)
    refute is_nil(new_pid)
    refute new_pid == pid, "Dial did not crash, so this test is invalid."

    assert {Belfrage.Dials.CircuitBreaker, "circuit_breaker", expected_default_value} ==
             :sys.get_state(:circuit_breaker)
  end

  test "notifies dials of new dial data" do
    dials_data = %{
      "circuit_breaker" => "false"
    }

    Belfrage.DialsSupervisor.notify(:dials_changed, dials_data)

    assert false == Belfrage.Dial.state(:circuit_breaker)
  end
end
