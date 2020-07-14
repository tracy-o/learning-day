defmodule Belfrage.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children(env: env) do
    router_options =
      case env do
        :test -> [scheme: :http, port: 7081]
        :end_to_end -> [scheme: :http, port: 7082]
        :routes_test -> [scheme: :http, port: 7083]
        :smoke_test -> [scheme: :http, port: 7084]
        :dev -> [scheme: :http, port: 7080]
        :prod -> [scheme: :https, port: 7443]
      end

    [
      BelfrageWeb.Router.child_spec(router_options)
    ] ++ http_router(env) ++ default_children()
  end

  def default_children do
    [
      Belfrage.LoopsRegistry,
      Belfrage.LoopsSupervisor,
      Belfrage.Credentials.Refresh,
      Belfrage.DialsSupervisor,
      Belfrage.PoolMetrics,
      Belfrage.TelemetrySupervisor,
      worker(Cachex, [:cache, [limit: cachex_limit()]]),
      {EtsCleaner, cleaner_module: Belfrage.Cache.Cleaner, check_interval: 60_000}
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end

  defp cachex_limit(conf \\ Application.get_env(:cachex, :limit))

  defp cachex_limit(size: size, policy: policy, reclaim: reclaim, options: options) do
    {:limit, size, policy, reclaim, options}
  end

  defp http_router(:prod), do: [BelfrageWeb.Router.child_spec(scheme: :http, port: 7080)]
  defp http_router(_env), do: []
end
