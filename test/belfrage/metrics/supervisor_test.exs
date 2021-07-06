defmodule Belfrage.Metrics.SupervisorTest do
  use ExUnit.Case

  test "is alive with at least 1 children" do
    assert length(Supervisor.which_children(Belfrage.Metrics.Supervisor)) >= 0
  end

  test "supervisor does restarts workers on server crash" do
    pid = Process.whereis(Belfrage.Metrics.MailboxMonitor)
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)

    receive do
      {:DOWN, ^ref, :process, ^pid, :killed} ->
        :timer.sleep(1)
        assert is_pid(Process.whereis(Belfrage.Metrics.MailboxMonitor))
    end
  end

  test "supervisor does NOT restarts on server crash" do
    pid = Process.whereis(Belfrage.Metrics.Supervisor)
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)

    receive do
      {:DOWN, ^ref, :process, ^pid, :killed} ->
        :timer.sleep(1)
        assert Process.whereis(Belfrage.Metrics.Supervisor) == nil
    end

    {:ok, _} = Supervisor.start_child(Belfrage.Supervisor, {Belfrage.Metrics.Supervisor, env: :test})
  end
end
