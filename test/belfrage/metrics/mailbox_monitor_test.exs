defmodule Belfrage.Metrics.MailboxMonitorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Metrics.MailboxMonitor
  alias Belfrage.EventMock

  describe "monitoring processes" do
    defmodule MailboxMonitorServer do
      use GenServer

      @impl true
      def init(state \\ nil) do
        {:ok, state}
      end

      def start_link(name: name) do
        GenServer.start_link(__MODULE__, nil, name: name)
      end
    end

    test "does not report mailbox size when process is not running" do
      expect_no_metric()
      expect_log("Error retrieving the mailbox size for test_mailbox_monitor_server, pid could not be found")
      monitor_mailbox_size(:test_mailbox_monitor_server)
    end

    test "reports mailbox size of zero when process mailbox is empty" do
      start_supervised!({MailboxMonitorServer, name: :test_mailbox_monitor_server})
      expect_metric("gen_server.test_mailbox_monitor_server.mailbox_size", 0)
      monitor_mailbox_size(:test_mailbox_monitor_server)
    end

    test "reports mailbox size when process has messages in mailbox" do
      server_pid = start_supervised!({MailboxMonitorServer, name: :test_mailbox_monitor_server})
      suspend(server_pid)

      send(server_pid, :hello)
      send(server_pid, :hello)

      expect_metric("gen_server.test_mailbox_monitor_server.mailbox_size", 2)
      monitor_mailbox_size(:test_mailbox_monitor_server)
    end

    test "reports mailbox size for multiple processes" do
      server1_pid = start_supervised!({MailboxMonitorServer, name: :test_mailbox_monitor_server1}, id: :server1)
      server2_pid = start_supervised!({MailboxMonitorServer, name: :test_mailbox_monitor_server2}, id: :server2)
      suspend(server1_pid)
      suspend(server2_pid)

      send(server1_pid, :hello)
      send(server1_pid, :hello)
      send(server2_pid, :hello)

      expect_metric("gen_server.test_mailbox_monitor_server1.mailbox_size", 2)
      expect_metric("gen_server.test_mailbox_monitor_server2.mailbox_size", 1)

      monitor_mailbox_size([:test_mailbox_monitor_server1, :test_mailbox_monitor_server2])
    end
  end

  describe "monitoring loops" do
    # `Module.concat` prevents the module from being nested under the test's
    # module name. This is necessary because loops must be under `Routes.Specs`
    defmodule Module.concat([Routes, Specs, MailboxMonitorLoop]) do
      def specs do
        %{
          platform: Webcore
        }
      end
    end

    test "does not report mailbox size when loop is not running" do
      expect_no_metric()
      expect_log("Error retrieving the mailbox size for loop MailboxMonitorLoop, pid could not be found")
      monitor_mailbox_size({:loop, "MailboxMonitorLoop"})
    end

    test "reports mailbox size of 0 when loop has no messages in mailbox" do
      Mox.stub(Belfrage.Dials.ServerMock, :state, fn :personalisation -> true end)
      Mox.stub(Belfrage.Authentication.FlagpoleMock, :state, fn -> true end)

      start_supervised!({Belfrage.Loop, "MailboxMonitorLoop"})
      expect_metric("loop.MailboxMonitorLoop.mailbox_size", 0)
      monitor_mailbox_size({:loop, "MailboxMonitorLoop"})
    end

    test "reports mailbox size when loop has messages in mailbox" do
      Mox.stub(Belfrage.Dials.ServerMock, :state, fn :personalisation -> true end)
      Mox.stub(Belfrage.Authentication.FlagpoleMock, :state, fn -> true end)

      loop_pid = start_supervised!({Belfrage.Loop, "MailboxMonitorLoop"})
      suspend(loop_pid)

      send(loop_pid, :hello)
      send(loop_pid, :hello)

      expect_metric("loop.MailboxMonitorLoop.mailbox_size", 2)
      monitor_mailbox_size({:loop, "MailboxMonitorLoop"})
    end
  end

  defp suspend(pid) do
    # Suspend the process so that it doesn't process any messages and they
    # remain in its mailbox
    :sys.suspend(pid, :infinity)
  end

  defp monitor_mailbox_size(servers) do
    pid = start_supervised!({MailboxMonitor, name: :test_mailbox_monitor, servers: List.wrap(servers)})
    # Make sure :refresh message is processed by sending a blocking message
    :sys.get_state(pid)
  end

  defp expect_no_metric() do
    expect(EventMock, :record, 0, fn :metric, _, _, _ -> true end)
  end

  defp expect_metric(name, value) do
    expect(EventMock, :record, 1, fn :metric, :gauge, ^name, value: ^value -> true end)
  end

  defp expect_log(message) do
    expect(EventMock, :record, fn :log, :info, %{msg: ^message} -> true end)
  end
end
