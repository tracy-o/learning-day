defmodule Ingress.Supervisor do
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
      Ingress.LoopsRegistry,
      Ingress.LoopsSupervisor
    ]
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args) ++ hackney_setup(), strategy: :one_for_one)
  end

  defp hackney_setup do
    [:hackney_pool.child_spec(:origin_pool, timeout: 1000, max_connections: 20000)]
  end
end
