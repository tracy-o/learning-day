defmodule Belfrage.GenServerMonitorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.GenServerMonitor
  alias Belfrage.TestGenServer

  setup do
    start_supervised!(GenServerMonitor)
    start_supervised!(TestGenServer, id: :test_server_one)
    start_supervised!({TestGenServer, name: :test_server_two}, id: :test_server_two)

    :ok
  end

  describe "handle_info/2" do
    test "reports the queue length of zero when the queue is empty" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.TestGenServer.queue_length", value: 0 -> true end)

      assert {:noreply, %{servers: [Belfrage.TestGenServer]}} =
               GenServerMonitor.handle_info(:refresh, %{servers: [Belfrage.TestGenServer]})
    end

    test "reports the queue length when the queue is not empty" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.TestGenServer.queue_length", value: 2 -> true end)

      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)

      Process.sleep(100)

      assert {:noreply, %{servers: [Belfrage.TestGenServer]}} =
               GenServerMonitor.handle_info(:refresh, %{servers: [Belfrage.TestGenServer]})
    end

    test "reports the queue length for more than one server" do
      Belfrage.EventMock
      |> expect(:record, fn :metric, :gauge, "gen_server.TestGenServer.queue_length", value: 2 -> true end)
      |> expect(:record, fn :metric, :gauge, "gen_server.test_server_two.queue_length", value: 2 -> true end)

      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(Belfrage.TestGenServer)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)
      TestGenServer.work(:test_server_two)

      Process.sleep(100)

      assert {:noreply, %{servers: [Belfrage.TestGenServer, :test_server_two]}} =
               GenServerMonitor.handle_info(:refresh, %{servers: [Belfrage.TestGenServer, :test_server_two]})
    end

    test "does not report when the gen_server is not running" do
      Belfrage.EventMock
      |> expect(:record, 0, fn :metric, :gauge, _name, _opts -> true end)

      assert {:noreply, %{servers: [:missing_server]}} =
               GenServerMonitor.handle_info(:refresh, %{servers: [:missing_server]})
    end
  end
end
