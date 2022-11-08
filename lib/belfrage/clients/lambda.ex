defmodule Belfrage.Clients.Lambda do
  require Logger
  require Belfrage.Xray

  alias Belfrage.{AWS}

  @lambda_timeout Application.get_env(:belfrage, :lambda_timeout)

  @callback call(any, any, any, any) :: any

  def call(credentials, function, payload, opts \\ [])

  def call(%AWS.Credentials{}, function, payload, opts) do
    if has_invalid_query_string?(payload) do
      {:error, :invalid_query_string}
    else
      make_request(%AWS.Credentials{}, function, payload, opts)
    end
  end

  def make_request(credentials = %AWS.Credentials{}, function, payload, opts) do
    lambda_response =
      aws().request(
        AWS.Lambda.invoke(function, payload, %{}, opts),
        security_token: credentials.session_token,
        access_key_id: credentials.access_key_id,
        secret_access_key: credentials.secret_access_key,
        http_opts: [timeout: @lambda_timeout, pool_name: :Webcore]
      )

    case lambda_response do
      {:ok, body} -> {:ok, body}
      {:error, {:http_error, 404, response}} -> function_not_found(response)
      {:error, {:http_error, status_code, response}} -> failed_to_invoke_lambda(status_code, response)
      {:error, :timeout} -> failed_to_invoke_lambda(408, :timeout)
      {:error, nil} -> failed_to_invoke_lambda(nil, nil)
    end
  end

  defp function_not_found(response) do
    Logger.log(:error, "Lambda function not found", %{
      response: response.body
    })

    {:error, :function_not_found}
  end

  defp failed_to_invoke_lambda(nil, nil) do
    Logger.log(:error, "Failed to Invoke Lambda")

    {:error, :invoke_failure}
  end

  defp failed_to_invoke_lambda(status_code, :timeout) do
    Logger.log(:error, "The Lambda Invokation timed out", %{
      status: status_code
    })

    {:error, :invoke_timeout}
  end

  defp failed_to_invoke_lambda(status_code, response) do
    Logger.log(:error, "Failed to Invoke Lambda", %{
      status: status_code,
      response: inspect(response)
    })

    {:error, :invoke_failure}
  end

  defp aws(), do: Application.get_env(:belfrage, :aws)

  defp has_invalid_query_string?(%{queryStringParameters: query_string_params}) do
    Enum.any?(query_string_params, fn {_k, v} -> not String.valid?(v) end)
  end

  defp has_invalid_query_string?(_payload), do: false
end
