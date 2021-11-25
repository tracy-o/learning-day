defmodule Belfrage.Clients.Lambda do
  require Belfrage.Xray
  import Belfrage.Metrics.LatencyMonitor, only: [checkpoint: 2]

  alias Belfrage.{AWS, Event}

  @aws Application.get_env(:belfrage, :aws)
  @lambda_timeout Application.get_env(:belfrage, :lambda_timeout)

  @callback call(String.t(), String.t(), Belfrage.Struct.Request.t(), String.t(), List.t()) :: Tuple.t()

  def call(credentials = %AWS.Credentials{}, function, payload, request_id, opts \\ []) do
    checkpoint(request_id, :origin_request_sent)

    lambda_response =
      Belfrage.Xray.trace_subsegment "invoke-lambda-call" do
        @aws.request(
          AWS.Lambda.invoke(function, payload, %{}, opts),
          security_token: credentials.session_token,
          access_key_id: credentials.access_key_id,
          secret_access_key: credentials.secret_access_key,
          http_opts: [timeout: @lambda_timeout, pool_name: :Webcore]
        )
      end

    checkpoint(request_id, :origin_response_received)

    case lambda_response do
      {:ok, body} -> {:ok, body}
      {:error, {:http_error, 404, response}} -> function_not_found(response)
      {:error, {:http_error, status_code, response}} -> failed_to_invoke_lambda(status_code, response)
      {:error, :timeout} -> failed_to_invoke_lambda(408, :timeout)
      {:error, nil} -> failed_to_invoke_lambda(nil, nil)
    end
  end

  defp function_not_found(response) do
    Event.record(:log, :error, %{
      message: "Lambda function not found",
      response: response.body
    })

    {:error, :function_not_found}
  end

  defp failed_to_invoke_lambda(nil, nil) do
    Event.record(:log, :error, %{
      message: "Failed to Invoke Lambda"
    })

    {:error, :invoke_failure}
  end

  defp failed_to_invoke_lambda(status_code, :timeout) do
    Event.record(:log, :error, %{
      message: "The Lambda Invokation timed out",
      status: status_code
    })

    {:error, :invoke_timeout}
  end

  defp failed_to_invoke_lambda(status_code, response) do
    Belfrage.Event.record(:log, :error, %{
      message: "Failed to Invoke Lambda",
      status: status_code,
      response: inspect(response)
    })

    {:error, :invoke_failure}
  end
end
