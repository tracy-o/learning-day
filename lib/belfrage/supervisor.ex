defmodule Belfrage.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children(env: env) do
    conditional_servers(env) ++
      [
        Belfrage.RouteSpecSupervisor,
        {Finch, finch_opts()},
        {BelfrageWeb.Router, router_options(env)},
        Belfrage.RouteStateRegistry,
        Belfrage.RouteStateSupervisor,
        {Belfrage.Authentication.Supervisor, [env: env]},
        {Belfrage.Dials.Supervisor, [env: env]},
        {Belfrage.Metrics.Supervisor, [env: env]},
        {Belfrage.Mvt.Supervisor, [env: env]},
        {Belfrage.Cache.Supervisor, [env: env]},
        {Belfrage.Services.Webcore.Supervisor, [env: env]},
        {Belfrage.NewsApps.Supervisor, [env: env]},
        {Belfrage.SupervisorObserver, get_observed_ids()}
      ]
  end

  def get_observed_ids() do
    [
      Belfrage.RouteSpecSupervisor,
      Belfrage.RouteStateSupervisor,
      Belfrage.Authentication.Supervisor,
      Belfrage.Dials.Supervisor,
      Belfrage.Metrics.Supervisor,
      Belfrage.Mvt.Supervisor,
      Belfrage.Services.Webcore.Supervisor,
      Belfrage.NewsApps.Supervisor
    ]
  end

  defp finch_opts() do
    bucket = Application.get_env(:belfrage, :ccp_s3_bucket)
    region = Application.get_env(:ex_aws, :region)

    [
      name: Finch,
      pools: %{
        :default => [size: 512, conn_opts: [transport_opts: {:verify, :verify_none}]],
        "https://#{bucket}.s3-#{region}.amazonaws.com" => [
          size: 2048,
          conn_opts: [
            transport_opts: [
              {:inet6, true}
            ]
          ]
        ],
        "https://sts.#{region}.amazonaws.com" => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:inet6, true}
            ]
          ]
        ],
        "https://lambda.#{region}.amazonaws.com" => [
          size: 1024,
          conn_opts: [
            transport_opts: [
              {:inet6, true}
            ]
          ]
        ],
        Application.get_env(:belfrage, :philippa_endpoint) => [size: 1024],
        Application.get_env(:belfrage, :trevor_endpoint) => [size: 1024],
        Application.get_env(:belfrage, :walter_endpoint) => [size: 1024],
        Application.get_env(:belfrage, :karanga_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:verify, :verify_none}
            ]
          ]
        ],
        endpoint(Application.get_env(:belfrage, :authentication)["account_jwk_uri"]) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:verify, :verify_none}
            ]
          ]
        ],
        endpoint(Application.get_env(:belfrage, :authentication)["idcta_config_uri"]) => [size: 512],
        endpoint(Application.get_env(:belfrage, :mvt)[:slots_file_location]) => [size: 512],
        Application.get_env(:belfrage, :simorgh_endpoint) => [size: 512],
        Application.get_env(:belfrage, :origin_simulator) => [size: 512],
        Application.get_env(:belfrage, :mozart_news_endpoint) => [
          size: 1024,
          conn_opts: [
            transport_opts: [
              {:verify, :verify_none},
              {:inet6, true}
            ]
          ]
        ],
        Application.get_env(:belfrage, :mozart_sport_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:verify, :verify_none},
              {:inet6, true}
            ]
          ]
        ],
        Application.get_env(:belfrage, :mozart_weather_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:verify, :verify_none},
              {:inet6, true}
            ]
          ]
        ],
        Application.get_env(:belfrage, :programmes_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:verify, :verify_none}
            ]
          ]
        ],
        Application.get_env(:belfrage, :ares_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:cacertfile, Application.get_env(:finch, :cacertfile)},
              {:certfile, Application.get_env(:finch, :certfile)},
              {:keyfile, Application.get_env(:finch, :keyfile)},
              {:verify, :verify_peer}
            ]
          ]
        ],
        Application.get_env(:belfrage, :fabl_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:cacertfile, Application.get_env(:finch, :cacertfile)},
              {:certfile, Application.get_env(:finch, :certfile)},
              {:keyfile, Application.get_env(:finch, :keyfile)},
              {:verify, :verify_peer}
            ]
          ]
        ],
        Application.get_env(:belfrage, :morph_router_endpoint) => [
          size: 512,
          conn_opts: [
            transport_opts: [
              {:cacertfile, Application.get_env(:finch, :cacertfile)},
              {:certfile, Application.get_env(:finch, :certfile)},
              {:keyfile, Application.get_env(:finch, :keyfile)},
              {:verify, :verify_peer}
            ]
          ]
        ]
      }
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 40)
  end

  defp conditional_servers(:prod) do
    # this is due to the www stack still handling the TLS termination,
    # it should go soonish.
    [BelfrageWeb.Router.child_spec(scheme: :https, port: 7443)]
  end

  defp conditional_servers(_) do
    [Belfrage.Utils.Current.Mock]
  end

  defp router_options(env) do
    case env do
      :test -> [scheme: :http, port: 7081]
      :smoke_test -> [scheme: :http, port: 7084]
      :dev -> [scheme: :http, port: 7080]
      :prod -> [scheme: :http, port: 7080]
    end
  end

  defp endpoint(url) do
    url = URI.parse(url)

    "#{url.scheme}://#{url.host}"
  end
end
