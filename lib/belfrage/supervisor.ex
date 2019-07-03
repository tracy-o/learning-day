defmodule Belfrage.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children(env: env) do
    router_options =
      case env do
        :test -> [scheme: :http, port: 7081]
        :dev -> [scheme: :http, port: 7080]
        :prod -> [scheme: :https, port: 7443]
      end

    [
      {IngressWeb.Router, router_options}
    ] ++ default_children()
  end

  def default_children do
    [
      Belfrage.LoopsRegistry,
      Belfrage.LoopsSupervisor,
      Belfrage.Cache.STS,
      worker(Cachex, [:cache, []])
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end
end
