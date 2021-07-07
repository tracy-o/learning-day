defmodule Belfrage.Metrics.MailboxMonitorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Metrics.MailboxMonitor, TestGenServer}
  alias Belfrage.EventMock

  setup do
    start_supervised!({TestGenServer, name: :test_server_one}, id: :test_server_one)
    start_supervised!({TestGenServer, name: :test_server_two}, id: :test_server_two)
    :ok
  end

  defp expect_record_event(:log, level, message) do
    expect(EventMock, :record, fn :log, ^level, %{msg: ^message} -> true end)
  end

  defp expect_record_event(count, :metric, :gauge, metric, value) do
    expect(EventMock, :record, count, fn :metric, :gauge, ^metric, value: ^value -> true end)
  end

  defp refresh_mailbox_monitor_assertion(servers) do
    assert {:noreply, %{servers: ^servers}} = MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: servers})
  end

  describe "handle_info/2 with generic processes" do
    test "reports the mailbox size of zero when the mailbox is empty" do
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 0)

      refresh_mailbox_monitor_assertion([:test_server_one])
    end

    test "reports the mailbox size when the mailbox is not empty" do
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 2)

      ref = make_ref()

      TestGenServer.work(:test_server_one, {:work, self(), ref})
      TestGenServer.work(:test_server_one)
      TestGenServer.work(:test_server_one)

      assert_receive {:work, ^ref}

      refresh_mailbox_monitor_assertion([:test_server_one])
    end

    test "reports the mailbox size for more than one server" do
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 2)
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_two.mailbox_size", 3)

      ref_one = make_ref()
      ref_two = make_ref()

      TestGenServer.work(:test_server_one, {:work, self(), ref_one})
      TestGenServer.work(:test_server_one)
      TestGenServer.work(:test_server_one)

      TestGenServer.work(:test_server_two, {:work, self(), ref_two})
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)

      assert_receive {:work, ^ref_one}
      assert_receive {:work, ^ref_two}

      refresh_mailbox_monitor_assertion([:test_server_one, :test_server_two])
    end

    test "does not report when the gen_server is not running" do
      expect_record_event(0, :metric, :gauge, "gen_server.missing_server.mailbox_size", 0)

      refresh_mailbox_monitor_assertion([:missing_server])
    end

    test "logs an info message when the gen_server is not running" do
      expect_record_event(:log, :info, "Error retrieving the mailbox size for missing_server, pid could not be found")

      refresh_mailbox_monitor_assertion([:missing_server])
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
      start_supervised!({Belfrage.Loop, "MailboxMonitorLoop"})
      expect_metric("loop.MailboxMonitorLoop.mailbox_size", 0)
      monitor_mailbox_size({:loop, "MailboxMonitorLoop"})
    end

    test "reports mailbox size when loop has messages in mailbox" do
      loop_pid = start_supervised!({Belfrage.Loop, "MailboxMonitorLoop"})
      # Suspend the loop so that it doesn't process any messages and they
      # remain in its mailbox
      :sys.suspend(loop_pid, :infinity)

      send(loop_pid, :hello)
      send(loop_pid, :hello)

      expect_metric("loop.MailboxMonitorLoop.mailbox_size", 2)
      monitor_mailbox_size({:loop, "MailboxMonitorLoop"})
    end
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
