defmodule Belfrage.Clients.AccountStub do
  @behaviour Belfrage.Clients.Account

  @impl true
  def get_jwk_keys() do
    {:ok, %{"keys" => Fixtures.AuthToken.keys()}}
  end

  @impl true
  def get_idcta_config() do
    {:ok, %{"id-availability" => "RED"}}
  end
end
