defmodule Belfrage.Supervisor do
  use Supervisor

  @http_pool_size 512

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # TODO: refactor definition of Cachex, according to
  # documentation it should be defined as:
  # {Cachex, [name: :cache, limit: cachex_limit()]}
  def children(env: env) do
    [
      {Finch, finch_opts()},
      {BelfrageWeb.Router, router_options(env)},
      Belfrage.RouteStateRegistry,
      Belfrage.RouteStateSupervisor,
      {Belfrage.Authentication.Supervisor, [env: env]},
      {Belfrage.Dials.Supervisor, [env: env]},
      {Belfrage.Metrics.Supervisor, [env: env]},
      {Cachex, name: :cache, limit: cachex_limit(), stats: true},
      Belfrage.Services.Webcore.Supervisor
    ] ++ http_router(env)
  end

  defp finch_opts() do
    bucket = Application.get_env(:belfrage, :ccp_s3_bucket)
    region = Application.get_env(:ex_aws, :region)

    [
      name: Finch,
      pools: %{
        "https://#{bucket}.s3-#{region}.amazonaws.com" => [size: @http_pool_size]
      }
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 40)
  end

  defp cachex_limit(conf \\ Application.get_env(:cachex, :limit))

  defp cachex_limit(size: size, policy: policy, reclaim: reclaim, options: options) do
    {:limit, size, policy, reclaim, options}
  end

  # this is due to the www stack still handling the TLS termination,
  # it should go soon.
  defp http_router(:prod), do: [BelfrageWeb.Router.child_spec(scheme: :https, port: 7443)]
  defp http_router(_env), do: []

  defp router_options(env) do
    case env do
      :test -> [scheme: :http, port: 7081]
      :smoke_test -> [scheme: :http, port: 7084]
      :dev -> [scheme: :http, port: 7080]
      :prod -> [scheme: :http, port: 7080]
    end
  end
end
