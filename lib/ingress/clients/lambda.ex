defmodule Ingress.Clients.Lambda do
  use ExMetrics
  @behaviour ExAws.Request.HttpClient

  @callback call(String.t(), String.t(), Ingress.Struct.Request.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    headers = Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
    Mojito.request(method, url, headers, body, build_options(http_opts))
  end

  def build_options(opts) do
    Keyword.merge(opts, protocols: [:http2, :http1], pool: false)
  end

  @aws_client Application.get_env(:ingress, :aws_client)

  def call(arn, function, payload) do
    case assume_role(arn, "ingress_session") do
      {:ok, %{body: credentials}} ->
        invoke_lambda(function, payload, credentials)

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

  defp assume_role(arn, role_name) do
    @aws_client.STS.assume_role(arn, role_name)
    |> @aws_client.request()
  end

  defp invoke_lambda(function, payload, credentials) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      case @aws_client.Lambda.invoke(function, payload, %{})
           |> @aws_client.request(
             security_token: credentials.session_token,
             access_key_id: credentials.access_key_id,
             secret_access_key: credentials.secret_access_key
           ) do
        {:ok, body} ->
          {:ok, body}

        {:error, {:http_error, status_code, response}} ->
          failed_to_invoke_lambda(status_code, response)

        {:error, _} ->
          failed_to_invoke_lambda(nil, nil)
      end
    end
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
