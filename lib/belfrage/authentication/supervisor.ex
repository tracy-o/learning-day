defmodule Belfrage.Authentication.Supervisor do
  use Supervisor

  alias Belfrage.Authentication

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 40)
  end

  defp children(env: env) when env in [:test, :routes_test, :smoke_test] do
    [
      Authentication.BBCID,
      Authentication.BBCID.AvailabilityPoller
    ]
  end

  defp children(_env) do
    [
      Authentication.BBCID,
      Authentication.BBCID.AvailabilityPoller,
      Authentication.Jwk
    ]
  end
end
