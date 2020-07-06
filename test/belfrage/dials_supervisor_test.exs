defmodule Belfrage.DialsSupervisorTest do
  use ExUnit.Case, async: true

  @dials_supervisor Belfrage.DialsSupervisor
  @dials_poller Belfrage.Dials.Poller
  @dials [Belfrage.Dials.CircuitBreaker]

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

    assert @dials == children
  end
end
