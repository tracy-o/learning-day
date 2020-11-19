defmodule Belfrage.Clients.AuthenticationStub do
  @behaviour Belfrage.Clients.Authentication

  @impl true
  def get_jwk_keys() do
    {:ok, %{"keys" => Fixtures.AuthToken.keys()}}
  end

  @impl true
  def get_idcta_config() do
    {:ok, %{"id-availability" => "RED"}}
  end
end
