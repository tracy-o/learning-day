defmodule Belfrage.Credentials.SupervisorTest do
  use ExUnit.Case, async: true

  test "on test is alive with no children" do
    assert Supervisor.which_children(Belfrage.Credentials.Supervisor) == []
  end

  test "supervisor restarts on server crash" do
    pid = Process.whereis(Belfrage.Credentials.Supervisor)
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)
    receive do
      {:DOWN, ^ref, :process, ^pid, :killed} ->
        :timer.sleep 1
        assert is_pid(Process.whereis(Belfrage.Credentials.Supervisor))
    after
      1000 ->
        raise :timeout
    end
  end
end
