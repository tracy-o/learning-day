defmodule Belfrage.Clients.JsonStub do
  @behaviour Belfrage.Clients.Json
  alias Belfrage.Authentication.{JWK, BBCID}

  @impl true
  def get(_url, JWK.Poller, :AccountAuthentication) do
    {:ok, %{"keys" => Fixtures.AuthToken.keys()}}
  end

  @impl true
  def get(_url, BBCID.AvailabilityPoller, :AccountAuthentication) do
    {:ok, %{"id-availability" => "RED"}}
  end
end
