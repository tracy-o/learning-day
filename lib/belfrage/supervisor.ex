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
        :dev -> [scheme: :http, port: 7080]
        :prod -> [scheme: :https, port: 7443]
      end

    [
      {BelfrageWeb.Router, router_options}
    ] ++ default_children()
  end

  def default_children do
    [
      Belfrage.LoopsRegistry,
      Belfrage.LoopsSupervisor,
      Belfrage.Credentials.Refresh,
      Belfrage.Dials,
      worker(Cachex, [:cache, []]),
      {EtsCleaner, cleaner_module: Belfrage.Cache.Cleaner, check_interval: 60_000}
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end
end
