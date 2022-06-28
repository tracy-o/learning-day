defmodule Belfrage.Metrics.NimblePoolTest do
  use ExUnit.Case
  import Belfrage.Test.MetricsHelper

  alias Belfrage.Metrics

  describe "track_nimble_pools/0" do
    setup do
      {socket, port} = given_udp_port_opened()

      start_reporter(
        metrics: Belfrage.Metrics.NimblePool.metrics(),
        formatter: :datadog,
        global_tags: [BBCEnvironment: "test"],
        port: port
      )

      {:ok, socket: socket}
    end

    test "tracks children of NimblePool.Supervisor", %{socket: socket} do
      start_finch()

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 3
         },
         %{
           pool_name: "localhost"
         }},
        fn -> Metrics.NimblePool.track_pools(TestFinch.PoolSupervisor) end
      )

      assert_reported(
        socket,
        Enum.join(
          [
            "nimble_pool.available_workers.count:3|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )
    end

    test "tracks checkouts", %{socket: socket} do
      start_finch()

      spawn(fn -> use_worker() end)

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 2
         },
         %{
           pool_name: "localhost"
         }},
        fn -> Metrics.NimblePool.track_pools(TestFinch.PoolSupervisor) end
      )

      assert_reported(
        socket,
        Enum.join(
          [
            "nimble_pool.available_workers.count:2|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )

      spawn(fn -> use_worker() end)

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 1
         },
         %{
           pool_name: "localhost"
         }},
        fn -> Metrics.NimblePool.track_pools(TestFinch.PoolSupervisor) end
      )

      assert_reported(
        socket,
        Enum.join(
          [
            "nimble_pool.available_workers.count:1|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )
    end
  end

  defp start_finch() do
    start_supervised!({Finch, [name: TestFinch, pools: %{"http://localhost:1234" => [size: 3]}]})
  end

  defp use_worker() do
    {pool, _} = Finch.PoolManager.lookup_pool(TestFinch, {:http, "localhost", 1234})

    NimblePool.checkout!(pool, :checkout, fn {_pid, _}, _port ->
      Process.sleep(100)
      {nil, :ok}
    end)
  end
end
