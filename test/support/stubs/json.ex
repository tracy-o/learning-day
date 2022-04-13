defmodule Belfrage.Clients.JsonStub do
  @behaviour Belfrage.Clients.Json

  @impl true
  def get(url, "jwk", :AccountAuthentication) do
    {:ok, %{"keys" => Fixtures.AuthToken.keys()}}
  end

  @impl true
  def get(url, "idcta_config", :AccountAuthentication) do
    {:ok, %{"id-availability" => "RED"}}
  end
end
