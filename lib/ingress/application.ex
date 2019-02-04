defmodule Ingress.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: Ingress,
        options: [port: Application.fetch_env!(:ingress, :http_port), protocol_options: [max_keepalive: 5_000_000]]
      ),
      # Starts a worker by calling: Ingress.Worker.start_link(arg)
      # {Ingress.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ingress.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
