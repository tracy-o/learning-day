defmodule Belfrage.Authentication.SupervisorTest do
  use ExUnit.Case, async: true

  test "on test is alive with no children" do
    assert Supervisor.which_children(Belfrage.Authentication.Supervisor) == []
  end

  test "supervisor restarts on server crash" do
    pid = Process.whereis(Belfrage.Authentication.Supervisor)
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)
    receive do
      {:DOWN, ^ref, :process, ^pid, :killed} ->
        :timer.sleep 1
        assert is_pid(Process.whereis(Belfrage.Authentication.Supervisor))
    end
  end
end
