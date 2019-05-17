defmodule Ingress.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children(env: :prod) do
    [
      {IngressWeb.Router, [scheme: :https, port: 7443]},
      {IngressWeb.Router, [scheme: :http, port: 7080]}
    ] ++ default_children()
  end

  def children(env: env) do
    port =
      case env do
        :test -> 7080
        :dev -> 7081
      end

    [
      {IngressWeb.Router, [scheme: :http, port: port]}
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
    Supervisor.init(children(args), strategy: :one_for_one)
  end
end
