defmodule Belfrage.Clients.JsonStub do
  @behaviour Belfrage.Clients.Json
  alias Belfrage.Authentication.{JWK, BBCID}

  @impl true
  def get(url, JWK.Poller, :AccountAuthentication) do
    {:ok, %{"keys" => Fixtures.AuthToken.keys()}}
  end

  @impl true
  def get(url, BBCID.AvailabilityPoller, :AccountAuthentication) do
    {:ok, %{"id-availability" => "RED"}}
  end
end
