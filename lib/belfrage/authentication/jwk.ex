defmodule Belfrage.Authentication.Jwk do
  use GenServer

  @refresh_rate 3_600_000
  @jwk_keys %{
    "keys" => [
      %{
        "kty" => "EC",
        "kid" => "SOME_EC_KEY_ID",
        "crv" => "P-256",
        "x" => "EVs_o5-uQbTjL3chynL4wXgUg2R9q9UU8I5mEovUf84",
        "y" => "kGe5DgSIycKp8w9aJmoHhB1sB3QTugfnRWm5nU_TzsY",
        "alg" => "ES256",
        "use" => "sig"
      }
    ]
  }

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_keys() do
    GenServer.call(__MODULE__, :state)
  end

  def refresh_now() do
    Process.send(__MODULE__, :refresh, [])
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
    Process.send_after(__MODULE__, :refresh, @refresh_rate)
  end

  defp fetch_jwk_keys do
    {:ok, @jwk_keys}
  end
end
