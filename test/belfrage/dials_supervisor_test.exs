defmodule Belfrage.DialsSupervisorTest do
  use ExUnit.Case, async: true

  @dials_supervisor Belfrage.DialsSupervisor
  @dials_poller Belfrage.Dials.Poller
  import ExUnit.CaptureLog

  defp expected_dial_default(dial_name) do
    Enum.find_value(Belfrage.DialsSupervisor.dial_config(), fn
      {dial_mod, ^dial_name, default_value} ->
        apply(dial_mod, :transform, [default_value])

      _other ->
        nil
    end)
  end

  test "dials supervisor is alive" do
    assert Process.whereis(@dials_supervisor) |> Process.alive?()
  end

  test "provides the dial_config/0 function" do
    assert [
             {Belfrage.Dials.CircuitBreaker, :circuit_breaker, _circuit_breaker_default},
             {Belfrage.Dials.LoggingLevel, :logging_level, _log_level_default},
             {Belfrage.Dials.TtlMultiplier, :ttl_multiplier, _ttl_multiplier_default}
           ] = Belfrage.DialsSupervisor.dial_config()
  end

  test "dials poller is up and running from the dials supervision tree" do
    child =
      Supervisor.which_children(@dials_supervisor)
      |> Enum.filter(fn {id, _, _, _} -> id == @dials_poller end)
      |> Enum.map(&elem(&1, 0))

    assert [@dials_poller] == child
  end

  test "dials are up and running from the dials supervision tree" do
    children =
      Supervisor.which_children(@dials_supervisor)
      |> Enum.map(&elem(&1, 0))

    assert [Belfrage.Dials.Poller, :ttl_multiplier, :logging_level, :circuit_breaker] == children
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
