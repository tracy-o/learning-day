defmodule Belfrage.Cache.STS do
  use GenServer

  @aws_client Application.get_env(:belfrage, :aws_client)
  @refresh_rate 3_000

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
      _ -> {:error, :credentials_not_found_in_cache}
    end
  end

  def handle_info(:refresh, state) do
    refresh_credentials()
    schedule_work()
    {:noreply, state}
  end

  # Avoids leak from Mojito? which
  # might not handle this info message correctly???
  # (Related to https://elixirforum.com/t/ssl-closed-error-in-genserver/19814)
  def handle_info({:ssl_closed, _}, state) do
    Stump.log(:info, %{
      msg: "Received :ssl_closed info message in :sts_cache_refresh process."
    })

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :refresh, @refresh_rate)
  end

  defp refresh_credentials do
    arn = Application.get_env(:belfrage, :webcore_lambda_role_arn)
    # This is where we could also look at the env, and
    # if on :dev, then fetch the credentials from the wormhole
    # instead of calling STS.
    with {:ok, credentials} <-
           @aws_client.STS.assume_role(arn, "belfrage_session")
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
