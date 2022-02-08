defmodule Belfrage.Authentication.Supervisor do
  use Supervisor

  alias Belfrage.Authentication.{BBCID, JWK}

  def start_link(_arg \\ nil) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children =
      [BBCID, BBCID.AvailabilityPoller, JWK]
      |> add_jwk_poller()

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end

  defp add_jwk_poller(children) do
    if Application.get_env(:belfrage, :jwk_polling_enabled) do
      children ++ [JWK.Poller]
    else
      children
    end
  end
end
