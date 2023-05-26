defmodule Belfrage.SupervisorTest do
  use ExUnit.Case, async: true

  alias Belfrage.SupervisorObserver

  test "ensure children supervisors are monitored by SupervisorObserver" do
    expected_observed_ids = Enum.sort(Belfrage.Supervisor.get_observed_ids())

    %{monitor_map: m_map, observed_ids: observed_ids} = SupervisorObserver.get_state(SupervisorObserver)
    monitor_ids = for {id, _ref} <- m_map, do: id

    assert expected_observed_ids == Enum.sort(observed_ids)
    assert expected_observed_ids == Enum.sort(monitor_ids)
  end
end
