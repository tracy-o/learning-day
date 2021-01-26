defmodule Belfrage.Authentication.Jwk do
  use GenServer
  use Belfrage.Authentication.JwkStaticKeys

  @authentication_client Application.get_env(:belfrage, :authentication_client)
  @refresh_rate 3_600_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_keys :: any
  def get_keys() do
    GenServer.call(__MODULE__, :state) |> Map.get("keys", [])
  end

  def get_key(alg, kid) do
    Enum.find_value(get_keys(), {:error, :public_key_not_found}, fn key ->
      key["kid"] == kid && key["alg"] == alg && {:ok, alg, key}
    end)
    |> case do
      {:ok, alg, key} ->
        Belfrage.Event.record(:log, :debug, %{
          msg: "Public key found",
          kid: kid,
          alg: alg
        })

        {:ok, alg, key}

      {:error, :public_key_not_found} ->
        Belfrage.Event.record(:log, :error, %{
          msg: "Public key not found",
          kid: kid,
          alg: alg
        })

        {:error, :public_key_not_found}
    end
  end

  def refresh_now() do
    Process.send(__MODULE__, :refresh, [])
  end

  @impl GenServer
  def init(_opts) do
    send(self(), :refresh)
    {:ok, get_static_keys()}
  end

  @impl GenServer
  def handle_info(:refresh, existing_state) do
    schedule_work()

    case @authentication_client.get_jwk_keys() do
      {:ok, jwk_keys} -> {:noreply, jwk_keys}
      {:error, _reason} -> {:noreply, existing_state}
    end
  end

  @impl GenServer
  def handle_call(:state, _from, jwk_keys) do
    {:reply, jwk_keys, jwk_keys}
  end

  defp schedule_work do
    Process.send_after(__MODULE__, :refresh, @refresh_rate)
  end
end
