defmodule Belfrage.Clients.Lambda do
  use ExMetrics
  @http_client Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)

  @behaviour ExAws.Request.HttpClient

  @callback call(String.t(), String.t(), Belfrage.Struct.Request.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    headers = Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
    http_opts = Keyword.put(http_opts, :headers, headers)
    @http_client.request(method, url, body, build_options(http_opts))
  end

  @timeout Application.get_env(:belfrage, :lambda_timeout)

  def build_options(opts) do
    Keyword.merge(opts, protocols: [:http1], timeout: @timeout)
  end

  @aws_client Application.get_env(:belfrage, :aws_client)

  def call(arn, function, payload) do
    with {:ok, credentials} <- Belfrage.Cache.STS.fetch(arn) do
      invoke_lambda(function, payload, credentials)
    else
      error -> error
    end
  end

  defp invoke_lambda(function, payload, credentials) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      case @aws_client.Lambda.invoke(function, payload, %{})
           |> @aws_client.request(
             security_token: credentials.session_token,
             access_key_id: credentials.access_key_id,
             secret_access_key: credentials.secret_access_key
           ) do
        {:ok, body} -> {:ok, body}
        {:error, {:http_error, 404, response}} -> function_not_found(response)
        {:error, {:http_error, status_code, response}} -> failed_to_invoke_lambda(status_code, response)
        {:error, :timeout} -> failed_to_invoke_lambda(408, :timeout)
        {:error, reason} -> failed_to_invoke_lambda(nil, {:catch_other_invoke_fails, reason})
      end
    end
  end

  defp function_not_found(response) do
    Stump.log(:error, %{
      message: "Function not found",
      status: 404,
      response: response.body
    })

    ExMetrics.increment("clients.lambda.function_not_found")
    {:error, :function_not_found}
  end

  defp failed_to_invoke_lambda(status_code, {:catch_other_invoke_fails, reason}) do
    Stump.log(:error, %{
      message: "Failed to Invoke Lambda",
      status: status_code,
      reason: reason
    })

    ExMetrics.increment("clients.lambda.invoke_failure")
    {:error, :failed_to_invoke_lambda}
  end

  defp failed_to_invoke_lambda(status_code, :timeout) do
    Stump.log(:error, %{
      message: "The Lambda Invokation timed out",
      status: status_code
    })

    ExMetrics.increment("clients.lambda.invoke_timeout")
    {:error, :failed_to_invoke_lambda}
  end

  defp failed_to_invoke_lambda(status_code, response) do
    Stump.log(:error, %{
      message: "Failed to Invoke Lambda",
      status: status_code,
      response: response.body
    })

    ExMetrics.increment("clients.lambda.invoke_failure")
    {:error, :failed_to_invoke_lambda}
  end
end
