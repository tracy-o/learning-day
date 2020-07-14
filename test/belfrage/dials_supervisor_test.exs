defmodule Belfrage.DialsSupervisorTest do
  use ExUnit.Case, async: true

  @dials_supervisor Belfrage.DialsSupervisor
  @dials_poller Belfrage.Dials.Poller
  @dials Belfrage.DialsSupervisor.dials()
  import ExUnit.CaptureLog

  test "dials supervisor is alive" do
    assert Process.whereis(@dials_supervisor) |> Process.alive?()
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
      |> Enum.filter(fn {id, _, _, _} -> id in @dials end)
      |> Enum.map(&elem(&1, 0))

    assert @dials == Enum.reverse(children)
  end

  test "when dial crashes, error is logged and dial is restarted" do
    supervised_dial = Belfrage.Dials.CircuitBreaker
    pid = Process.whereis(supervised_dial)

    assert capture_log(fn ->
             GenServer.cast(supervised_dial, {:dials_changed, %{"circuit_breaker" => "bar"}})
             :timer.sleep(100)
           end) =~ "no function clause matching"

    new_pid = GenServer.whereis(supervised_dial)
    refute is_nil(new_pid)
    refute new_pid == pid, "Dial did not crash, so this test is invalid."
  end
end
