defmodule Belfrage.Authentication.Jwk do
  use GenServer

  @account_client Application.get_env(:belfrage, :account_client)

  @refresh_rate 3_600_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_keys :: any
  def get_keys() do
    GenServer.call(__MODULE__, :state)
  end

  def refresh_now() do
    Process.send(__MODULE__, :refresh, [])
  end

  @impl GenServer
  def init(_opts) do
    send(self(), :refresh)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:refresh, _existing_state) do
    schedule_work()

    {:ok, jwk_keys} = @account_client.get_jwk_keys()
    {:noreply, jwk_keys}
  end

  @impl GenServer
  def handle_call(:state, _from, jwk_keys) do
    {:reply, jwk_keys, jwk_keys}
  end

  defp schedule_work do
    Process.send_after(__MODULE__, :refresh, @refresh_rate)
  end
end
