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

    test "tracks available workers", %{socket: socket} do
      start_finch(pool_size: 1)

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 1,
           queued_requests: 0
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
            "nimble_pool.available_workers.count:1|g|#pool_name:localhost,BBCEnvironment:test\nnimble_pool.queued_requests.count:0|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )

      spawn(fn -> use_worker() end)

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 0,
           queued_requests: 0
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
            "nimble_pool.available_workers.count:0|g|#pool_name:localhost,BBCEnvironment:test\nnimble_pool.queued_requests.count:0|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )
    end

    test "tracks queued requests", %{socket: socket} do
      start_finch(pool_size: 1)

      spawn(fn -> use_worker() end)

      spawn(fn -> use_worker() end)

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 0,
           queued_requests: 1
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
            "nimble_pool.available_workers.count:0|g|#pool_name:localhost,BBCEnvironment:test\nnimble_pool.queued_requests.count:1|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )

      spawn(fn -> use_worker() end)

      assert_metric(
        {[:nimble_pool, :status],
         %{
           available_workers: 0,
           queued_requests: 2
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
            "nimble_pool.available_workers.count:0|g|#pool_name:localhost,BBCEnvironment:test\nnimble_pool.queued_requests.count:2|g|#pool_name:localhost,BBCEnvironment:test"
          ],
          "\n"
        )
      )
    end
  end

  defp start_finch(opts) do
    start_supervised!(
      {Finch, [name: TestFinch, pools: %{"http://localhost:1234" => [size: Keyword.get(opts, :pool_size)]}]}
    )
  end

  defp use_worker() do
    {pool, _} = Finch.PoolManager.lookup_pool(TestFinch, {:http, "localhost", 1234})

    NimblePool.checkout!(pool, :checkout, fn {_pid, _}, _port ->
      Process.sleep(100)
      {nil, :ok}
    end)
  end
end
