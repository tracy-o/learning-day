defmodule Ingress.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def children([env: :prod]) do
    [
      {Ingress.Web, [scheme: :https, port: 7443]}
    ] ++ children(nil)
  end

  def children(_args) do
    [
      Ingress.LoopsRegistry,
      Ingress.LoopsSupervisor,
      {Ingress.Web, [scheme: :http, port: 7080]}
    ]
  end


  @impl true
  def init(args) do
    children = children(args)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
