defmodule Belfrage.Authentication.JWK.Poller do
  use GenServer

  alias Belfrage.Authentication.JWK

  @client Application.get_env(:belfrage, :json_client)
  @http_pool :AccountAuthentication
  @interval 3_600_000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, Keyword.get(opts, :interval, @interval), name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(interval) do
    schedule_polling()
    {:ok, interval}
  end

  @impl true
  def handle_info(:poll, interval) do
    schedule_polling(interval)

    with {:ok, %{"keys" => keys}} <- @client.get(jwk_uri(), @http_pool, name: "jwk") do
      JWK.update(keys)
    end

    {:noreply, interval}
  end

  defp jwk_uri, do: Application.get_env(:belfrage, :authentication)["account_jwk_uri"]

  defp schedule_polling(delay \\ 0) do
    Process.send_after(self(), :poll, delay)
  end
end
