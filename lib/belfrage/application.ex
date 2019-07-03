defmodule Ingress.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    Ingress.Supervisor.start_link(args)
  end
end
