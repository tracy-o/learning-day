defmodule Belfrage.Authentication.SupervisorTest do
  use ExUnit.Case, async: true

  alias Belfrage.Authentication

  test "supervisor restarts on server crash" do
    pid = Process.whereis(Authentication.Supervisor)
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)

    receive do
      {:DOWN, ^ref, :process, ^pid, :killed} ->
        :timer.sleep(1)
        assert is_pid(Process.whereis(Authentication.Supervisor))
    end
  end
end
