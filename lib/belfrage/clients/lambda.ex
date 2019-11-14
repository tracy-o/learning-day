defmodule Belfrage.Clients.Lambda do
  use ExMetrics
  alias Belfrage.Clients.HTTP

  @aws Application.get_env(:belfrage, :aws)
  @aws_lambda Application.get_env(:belfrage, :aws_lambda)
  @http_client Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)
  @lambda_timeout Application.get_env(:belfrage, :lambda_timeout)

  @behaviour ExAws.Request.HttpClient
  @callback call(String.t(), String.t(), Belfrage.Struct.Request.t(), List.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], _http_opts \\ []) do
    HTTP.Request.new(%{
      method: method,
      url: url,
      payload: body,
      timeout: @lambda_timeout,
      headers: headers
    })
    |> @http_client.execute()
  end

  def call(arn, function, payload, opts \\ []) do
    with {:ok, credentials} <- Belfrage.Credentials.Refresh.fetch(arn) do
      invoke_lambda(function, payload, credentials, opts)
    else
      error -> error
    end
  end

  defp invoke_lambda(function, payload, credentials, opts) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      case @aws_lambda.invoke(function, payload, %{}, opts)
           |> @aws.request(
             security_token: credentials.session_token,
             access_key_id: credentials.access_key_id,
             secret_access_key: credentials.secret_access_key
           ) do
        {:ok, body} -> {:ok, body}
        {:error, {:http_error, 404, response}} -> function_not_found(response)
        {:error, {:http_error, status_code, response}} -> failed_to_invoke_lambda(status_code, response)
        {:error, :timeout} -> failed_to_invoke_lambda(408, :timeout)
        {:error, nil} -> failed_to_invoke_lambda(nil, nil)
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

  defp failed_to_invoke_lambda(nil, nil) do
    Stump.log(:error, %{
      message: "Failed to Invoke Lambda"
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
      response: inspect(response)
    })

    ExMetrics.increment("clients.lambda.invoke_failure")
    {:error, :failed_to_invoke_lambda}
  end
end
