defmodule Ingress.Cache.STS do
  use GenServer

  @aws_client Application.get_env(:ingress, :aws_client)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :sts_cache_refresh)
  end

  def init(initial_state) do
    :ets.new(:sts_cache, [:set, :protected, :named_table, read_concurrency: true])
    GenServer.cast(self(), :refresh)

    schedule_work(Keyword.get(initial_state, :frequency_ms))
    {:ok, initial_state}
  end

  def fetch(arn) do
    case :ets.lookup(:sts_cache, arn) do
      [{^arn, credentials}] -> {:ok, credentials}
      _ -> {:error, :credentials_not_found_in_cache}
    end
  end

  def handle_cast(:refresh, state = [frequency_ms: frequency_ms]) do
    refresh_credentials()

    schedule_work(frequency_ms)

    {:noreply, state}
  end

  defp schedule_work(frequency_ms) do
    Process.send_after(self(), :refresh, frequency_ms)
  end

  defp refresh_credentials do
    arn = Application.get_env(:ingress, :webcore_lambda_role_arn)
    # This is where we could also look at the env, and
    # if on :dev, then fetch the credentials from the wormhole
    # instead of calling STS.
    with {:ok, credentials} <-
           @aws_client.STS.assume_role(arn, "ingress_session")
           |> @aws_client.request()
           |> format_response() do
      store_credentials(arn, credentials)
    else
      error -> error
    end
  end

  defp store_credentials(arn, credentials) do
    :ets.insert(:sts_cache, {arn, credentials})
  end

  defp store_credentials(_), do: nil

  defp format_response(sts_response) do
    case sts_response do
      {:ok, %{body: credentials}} ->
        {:ok, credentials}

      {:error, {:http_error, status_code, response}} ->
        failed_to_assume_role(status_code, response)

      {:error, _} ->
        failed_to_assume_role(nil, nil)
    end
  end

  defp failed_to_assume_role(status_code, response) do
    Stump.log(:error, %{
      message: "Failed to assume role",
      status: status_code,
      response: response
    })

    ExMetrics.increment("clients.lambda.assume_role_failure")
    {:error, :failed_to_assume_role}
  end
end
