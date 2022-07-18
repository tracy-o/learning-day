defmodule Belfrage.Authentication.JWK.Poller do
  use Belfrage.Poller, interval: Application.compile_env!(:belfrage, :poller_intervals)[:jwk]
  alias Belfrage.Authentication.JWK

  @http_pool :AccountAuthentication

  @impl Belfrage.Poller
  def poll() do
    with {:ok, %{"keys" => keys}} <- json_client().get(jwk_uri(), @http_pool, name: "jwk") do
      JWK.update(keys)
    end

    :ok
  end

  defp jwk_uri(), do: Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
  defp json_client(), do: Application.get_env(:belfrage, :json_client)
end
