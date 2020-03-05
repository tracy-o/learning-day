defmodule Belfrage.Credentials.Refresh do
  use GenServer
  @credential_strategy Application.get_env(:belfrage, :credential_strategy)

  @refresh_rate 600_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :sts_cache_refresh)
  end

  def init(initial_state) do
    :ets.new(:sts_cache, [:set, :protected, :named_table, read_concurrency: true])
    send(self(), :refresh)
    {:ok, initial_state}
  end

  def fetch(arn) do
    case :ets.lookup(:sts_cache, arn) do
      [{^arn, credentials}] -> {:ok, credentials}
      _ -> {:error, :credentials_not_found}
    end
  end

  def handle_info(:refresh, state) do
    schedule_work()
    refresh_credentials()

    {:noreply, state}
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  def handle_info(_any_message, state) do
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :refresh, @refresh_rate)
  end

  defp refresh_credentials do
    @credential_strategy.refresh_credential(Application.get_env(:belfrage, :webcore_lambda_role_arn), "webcore_session")
    |> store_credentials()
  end

  defp store_credentials({:ok, arn, _session_name, credentials}) do
    :ets.insert(:sts_cache, {arn, credentials})
  end

  defp store_credentials({:error, :failed_to_fetch_credentials}), do: :error
end
