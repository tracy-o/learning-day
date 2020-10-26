defmodule Belfrage.Authentication.Jwk do
  use GenServer

  @refresh_rate 3_600_000
  @jwk_keys %{
    "keys" => [
      %{
        "alg" => "RS384",
        "e" => "AQAB",
        "kid" => "kid",
        "kty" => "RSA",
        "n" => "lkjljxbcLSJHSL",
        "use" => "enc",
        "x5c" => ["AAA"],
        "x5t" => "dskjhfkjh"
      }
    ]
  }

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :jwk)
  end

  def get_keys() do
    GenServer.call(:jwk, :state)
  end

  def refresh_now() do
    Process.send(:jwk, :refresh, [])
  end

  @impl GenServer
  def init(initial_state) do
    send(self(), :refresh)
    {:ok, initial_state}
  end

  @impl GenServer
  def handle_info(:refresh, _existing_state) do
    schedule_work()

    {:ok, jwk_keys} = fetch_jwk_keys()
    {:noreply, jwk_keys}
  end

  @impl GenServer
  def handle_call(:state, _from, jwk_keys) when is_map(jwk_keys) do
    {:reply, jwk_keys, jwk_keys}
  end

  @impl GenServer
  def handle_call(:state, _from, _state) do
    {:reply, %{}, %{}}
  end

  defp schedule_work do
    Process.send_after(:jwk, :refresh, @refresh_rate)
  end

  defp fetch_jwk_keys do
    {:ok, @jwk_keys}
  end
end
