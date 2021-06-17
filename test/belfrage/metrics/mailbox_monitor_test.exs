defmodule Belfrage.Metrics.MailboxMonitorTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Metrics.MailboxMonitor
  alias Belfrage.TestGenServer
  alias Belfrage.{Loop, LoopsSupervisor}

  setup do
    start_supervised!({TestGenServer, name: :test_server_one}, id: :test_server_one)
    start_supervised!({TestGenServer, name: :test_server_two}, id: :test_server_two)
    start_supervised!(LoopsSupervisor.child_spec(name: :test_loop_supervisor, id: :test_loop_supervisor))
    :ok
  end

  defp increase_loop(loop_name) do
    {:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, loop_name}}}
    |> GenServer.cast({:inc, 200, "MyOrigin", true})
  end

  defp expect_record_event(:log, level, message) do
    expect(Belfrage.EventMock, :record, fn :log, level, %{msg: message} -> true end)
  end

  defp expect_record_event(count, :metric, :gauge, message, value) do
    expect(Belfrage.EventMock, :record, count, fn :metric, :gauge, message, value: value -> true end)
  end

  defp refresh_mailbox_monitor(servers) do
    MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: servers})
  end

  describe "handle_info/2 with generic processes" do
    test "reports the mailbox size of zero when the mailbox is empty" do
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 0)

      assert {:noreply, %{servers: [:test_server_one]}} = refresh_mailbox_monitor([:test_server_one])
    end

    test "reports the mailbox size when the mailbox is not empty" do
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 2)

      ref = make_ref()

      TestGenServer.work(:test_server_one, {:work, self(), ref})
      TestGenServer.work(:test_server_one)
      TestGenServer.work(:test_server_one)

      assert_receive {:work, ref}

      assert {:noreply, %{servers: [:test_server_one]}} = refresh_mailbox_monitor([:test_server_one])
    end

    test "reports the mailbox size for more than one server" do
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 2)
      expect_record_event(1, :metric, :gauge, "gen_server.test_server_one.mailbox_size", 3)

      ref_one = make_ref()
      ref_two = make_ref()

      TestGenServer.work(:test_server_one, {:work, self(), ref_one})
      TestGenServer.work(:test_server_one)
      TestGenServer.work(:test_server_one)

      TestGenServer.work(:test_server_two, {:work, self(), ref_two})
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)

      assert_receive {:work, ref}
      assert_receive {:work, ref_two}

      assert {:noreply, %{servers: [:test_server_one, :test_server_two]}} =
               refresh_mailbox_monitor([:test_server_one, :test_server_two])
    end

    test "does not report when the gen_server is not running" do
      expect_record_event(0, :metric, :gauge, "gen_server.missing_server.mailbox_size", 0)

      assert {:noreply, %{servers: [:missing_server]}} =
               MailboxMonitor.handle_info(:refresh, %{rate: 100, servers: [:missing_server]})
    end

    test "logs an info message when the gen_server is not running" do
      expect_record_event(:log, :info, "Error retrieving the mailbox size for missing_server, pid could not be found")

      assert {:noreply, %{servers: [:missing_server]}} = refresh_mailbox_monitor([:missing_server])
    end
  end

  describe "handle_info/2 with loops" do
    test "reports the mailbox size of zero when a loop has just started" do
      LoopsSupervisor.start_loop(:test_loop_supervisor, "HomePage")

      expect_record_event(1, :metric, :gauge, "loop.HomePage.mailbox_size", 0)

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} = refresh_mailbox_monitor([{:loop, "HomePage"}])
    end

    test "reports the mailbox size when a loop has received a call" do
      LoopsSupervisor.start_loop(:test_loop_supervisor, "HomePage")

      expect_record_event(1, :metric, :gauge, "loop.HomePage.mailbox_size", 1)

      increase_loop("HomePage")

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} = refresh_mailbox_monitor([{:loop, "HomePage"}])
    end

    test "does not report when the loop is not running" do
      expect_record_event(0, :metric, :gauge, "loop.HomePage.mailbox_size", 0)

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} = refresh_mailbox_monitor([{:loop, "HomePage"}])
    end

    test "logs an info message if a loop has not started" do
      expect_record_event(:log, :info, "Error retrieving the mailbox size for loop HomePage, pid could not be found")

      assert {:noreply, %{servers: [{:loop, "HomePage"}]}} = refresh_mailbox_monitor([{:loop, "HomePage"}])
    end
  end
end
