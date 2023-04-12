defmodule Belfrage.Clients.CCP do
  @moduledoc """
  The interface to the Belfrage Central Cache Processor (CCP)
  """
  require Logger
  alias Belfrage.{Envelope, Envelope.Request}

  @s3_not_found_response_code 403

  @type target :: pid() | {:global, atom()}
  @callback fetch(String.t()) ::
              {:ok, :content_not_found} | {:ok, Envelope.Response.t()}
  @callback put(Envelope.t()) :: :ok
  @callback put(Envelope.t(), target) :: :ok

  @spec fetch(String.t()) ::
          {:ok, :content_not_found} | {:ok, Envelope.Response.t()}
  def fetch(request_hash) do
    # TODO Investigate using internal S3 endpoints for secure fetches
    # https://aws.amazon.com/premiumsupport/knowledge-center/s3-private-connection-no-authentication/

    before_time = System.monotonic_time(:millisecond)

    ccp_response =
      Finch.build(
        :get,
        "https://#{s3_bucket()}.s3-#{s3_region()}.amazonaws.com/#{request_hash}"
      )
      |> FinchAPI.request(Finch,
        receive_timeout: Application.get_env(:belfrage, :s3_http_client_timeout)
      )

    timing = (System.monotonic_time(:millisecond) - before_time) |> abs
    :telemetry.execute([:belfrage, :service, :S3, :request, :timing], %{duration: timing})

    case ccp_response do
      {:ok, %Finch.Response{status: 200, body: cached_body}} ->
        Belfrage.Metrics.multi_execute(
          [[:belfrage, :service, :S3, :response, :"200"], [:belfrage, :platform, :response]],
          %{count: 1},
          %{status_code: 200, platform: "S3"}
        )

        {:ok, cached_body |> :erlang.binary_to_term()}

      {:ok, %Finch.Response{status: @s3_not_found_response_code}} ->
        :telemetry.execute([:belfrage, :service, :S3, :response, :not_found], %{count: 1})
        {:ok, :content_not_found}

      {:ok, response = %Finch.Response{status: status_code}} ->
        Belfrage.Metrics.multi_execute(
          [
            [:belfrage, :service, :S3, :response, String.to_atom(to_string(status_code))],
            [:belfrage, :platform, :response]
          ],
          %{count: 1},
          %{status_code: status_code, platform: "S3"}
        )

        :telemetry.execute([:belfrage, :ccp, :unexpected_response], %{})

        Logger.log(:error, "", %{
          msg: "Received an unexpected response from S3.",
          response: response
        })

        {:ok, :content_not_found}

      {:error, http_error} ->
        :telemetry.execute([:belfrage, :ccp, :fetch_error], %{})

        Logger.log(:error, "", %{
          msg: "Failed to fetch from S3.",
          error: http_error
        })

        {:ok, :content_not_found}
    end
  end

  @spec put(Envelope.t()) :: :ok | :error
  @spec put(Envelope.t(), target) :: :ok | :error
  def put(
        %Envelope{
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
        :telemetry.execute([:belfrage, :ccp, :put_error], %{})
        Logger.log(:error, "", %{msg: "Failed to send_nosuspend to CCP"})
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
    Logger.log(:error, "", %{msg: "Unexpected ccp target", error: unexpected_target})
  end

  defp cast_msg(req), do: {:"$gen_cast", req}

  defp s3_bucket do
    Application.get_env(:belfrage, :ccp_s3_bucket)
  end

  defp s3_region do
    Application.get_env(:ex_aws, :region)
  end
end
