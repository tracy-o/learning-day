defmodule Belfrage.MailboxMonitorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.MailboxMonitor
  alias Belfrage.TestGenServer

  setup do
    start_supervised!(MailboxMonitor)
    start_supervised!(TestGenServer, id: :test_server_one)
    start_supervised!({TestGenServer, name: :test_server_two}, id: :test_server_two)

    :ok
  end

  describe "handle_info/2" do
    test "reports the mailbox size of zero when the mailbox is empty" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.Belfrage_TestGenServer.mailbox_size", value: 0 -> true end)

      assert {:noreply, %{servers: [Belfrage.TestGenServer]}} =
               MailboxMonitor.handle_info(:refresh, %{servers: [Belfrage.TestGenServer]})
    end

    test "reports the mailbox size when the mailbox is not empty" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.Belfrage_TestGenServer.mailbox_size", value: 2 -> true end)

      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)

      Process.sleep(100)

      assert {:noreply, %{servers: [Belfrage.TestGenServer]}} =
               MailboxMonitor.handle_info(:refresh, %{servers: [Belfrage.TestGenServer]})
    end

    test "reports the mailbox size for more than one server" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.Belfrage_TestGenServer.mailbox_size", value: 2 -> true end)
      |> expect(:record, fn :metric, :gauge, "gen_server.test_server_two.mailbox_size", value: 2 -> true end)

      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)

      Process.sleep(100)

      assert {:noreply, %{servers: [Belfrage.TestGenServer, :test_server_two]}} =
               MailboxMonitor.handle_info(:refresh, %{servers: [Belfrage.TestGenServer, :test_server_two]})
    end

    test "does not report when the gen_server is not running" do
      Belfrage.EventMock
      |> expect(:record, 0, fn :metric, :gauge, _name, _opts -> true end)

      assert {:noreply, %{servers: [:missing_server]}} =
               MailboxMonitor.handle_info(:refresh, %{servers: [:missing_server]})
    end
  end
end
