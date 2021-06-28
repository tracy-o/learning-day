defmodule Belfrage.Clients.CCP do
  @moduledoc """
  The interface to the Belfrage Central Cache Processor (CCP)
  """
  alias Belfrage.{Clients, Struct, Struct.Request}

  @s3_not_found_response_code 403
  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)

  @type target :: pid() | {:global, atom()}
  @callback fetch(String.t(), String.t()) ::
              {:ok, :content_not_found} | {:ok, :fresh, Struct.Response.t()} | {:ok, :stale, Struct.Response.t()}
  @callback put(Struct.t()) :: :ok
  @callback put(Struct.t(), target) :: :ok

  @spec fetch(String.t(), String.t()) ::
          {:ok, :content_not_found} | {:ok, :fresh, Struct.Response.t()} | {:ok, :stale, Struct.Response.t()}
  def fetch(request_hash, request_id) do
    # TODO Investigate using internal S3 endpoints for secure fetches
    # https://aws.amazon.com/premiumsupport/knowledge-center/s3-private-connection-no-authentication/
    @http_client.execute(%Clients.HTTP.Request{
      method: :get,
      url: ~s(https://#{s3_bucket()}.s3-#{s3_region()}.amazonaws.com/#{request_hash}),
      request_id: request_id
    })
    |> case do
      {:ok, %Clients.HTTP.Response{status_code: 200, body: cached_body}} ->
        Belfrage.Metrics.Statix.increment("service.S3.response.200")
        {:ok, :stale, cached_body |> :erlang.binary_to_term()}

      {:ok, %Clients.HTTP.Response{status_code: @s3_not_found_response_code}} ->
        Belfrage.Metrics.Statix.increment("service.S3.response.not_found")
        {:ok, :content_not_found}

      {:ok, response = %Clients.HTTP.Response{status_code: status_code}} ->
        Belfrage.Metrics.Statix.increment("service.S3.response.#{status_code}")
        Belfrage.Event.record(:metric, :increment, "ccp.unexpected_response")

        Belfrage.Event.record(:log, :error, %{
          msg: "Received an unexpected response from S3.",
          response: response
        })

        {:ok, :content_not_found}

      {:error, http_error} ->
        Belfrage.Event.record(:metric, :increment, "ccp.fetch_error")

        Belfrage.Event.record(:log, :error, %{
          msg: "Failed to fetch from S3.",
          error: http_error
        })

        {:ok, :content_not_found}
    end
  end

  @spec put(Struct.t()) :: :ok | :error
  @spec put(Struct.t(), target) :: :ok | :error
  def put(
        %Struct{
          request: %Request{request_hash: request_hash},
          response: response
        },
        target \\ {:global, :belfrage_ccp}
      ) do
    case pid = target_pid(target) do
      :undefined -> :error
      _ -> send(pid, request_hash, response)
    end
  end

  # When you call :erlang.send_nosuspend and the port program representing the TCP socket
  # is busy, you'll get a 'false' return value indicating it failed because it was full
  #
  # see http://erlang.org/documentation/doc-5.8.2/erts-5.8.2/doc/html/erlang.html#send_nosuspend-3
  defp send(pid, request_hash, response) do
    sent = :erlang.send_nosuspend(pid, cast_msg({:put, request_hash, response}), [:noconnect])

    case sent do
      true ->
        :ok

      false ->
        Belfrage.Event.record(:metric, :increment, "ccp.put_error")
        Belfrage.Event.record(:log, :error, %{msg: "Failed to send_nosuspend to CCP"})
        :error
    end
  end

  defp target_pid({:global, target}) do
    :global.whereis_name(target)
  end

  defp target_pid(target) when is_pid(target) do
    target
  end

  defp target_pid(unexpected_target) do
    Belfrage.Event.record(:log, :error, %{msg: "Unexpected ccp target", error: unexpected_target})
  end

  defp cast_msg(req), do: {:"$gen_cast", req}

  defp s3_bucket do
    Application.get_env(:belfrage, :ccp_s3_bucket)
  end

  defp s3_region do
    Application.get_env(:ex_aws, :region)
  end
end
