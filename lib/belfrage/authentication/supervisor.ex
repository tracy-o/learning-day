defmodule Belfrage.Authentication.Supervisor do
  use Supervisor

  alias Belfrage.Authentication.{BBCID, JWK}

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    Supervisor.init(children(opts), strategy: :one_for_one, max_restarts: 40)
  end

  defp children(opts) do
    if Keyword.get(opts, :env) in [:dev, :test] do
      [BBCID, JWK]
    else
      [BBCID, JWK, BBCID.AvailabilityPoller, JWK.Poller]
    end
  end
end
