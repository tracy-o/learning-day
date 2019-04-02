defmodule Ingress.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children([env: :prod]) do
    [
      {IngressWeb.Router, [scheme: :https, port: 7443]}
    ] ++ children(nil)
  end

  def children(_args) do
    [
      Ingress.LoopsRegistry,
      Ingress.LoopsSupervisor,
      {IngressWeb.Router, [scheme: :http, port: 7080]}
    ]
  end


  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end
end
