defmodule Ingress.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    IO.inspect(node(), label: "Starting on node named")
    Ingress.Supervisor.start_link(args)
  end
end
