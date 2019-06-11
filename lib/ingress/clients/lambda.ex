defmodule Ingress.Clients.Lambda do
  use ExMetrics
  @behaviour ExAws.Request.HttpClient

  @callback call(String.t(), String.t(), Ingress.Struct.Request.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    headers = Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
    Mojito.request(method, url, headers, body, build_options(http_opts))
  end

  @aws_client Application.get_env(:ingress, :aws_client)

  def call(arn, function, payload) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      with {:ok, %{body: credentials}} <- assume_role(arn, "presentation layer role") do
        invoke_lambda(function, payload, credentials)
      else
        {:error, reason} ->
          Stump.log(:error, %{message: "Failed to assume role", reason: reason})
          ExMetrics.increment("clients.lambda.assume_role_failure")
          {:error, :failed_to_assume_role}
      end
    end
  end

  defp assume_role(arn, role_name) do
    @aws_client.STS.assume_role(arn, role_name)
    |> @aws_client.request()
  end

  defp invoke_lambda(function, payload, credentials) do
    with {:ok, body} <-
           @aws_client.Lambda.invoke(function, payload, %{})
           |> @aws_client.request(
             security_token: credentials.session_token,
             access_key_id: credentials.access_key_id,
             secret_access_key: credentials.secret_access_key
           ) do
      {:ok, body}
    else
      {:error, reason} ->
        Stump.log(:error, %{message: "Failed to Invoke Lambda", reason: reason})
        ExMetrics.increment("clients.lambda.invoke_failure")
        {:error, :failed_to_invoke_lambda}
    end
  end

  def build_options(opts) do
    Keyword.merge(opts, protocols: [:http2, :http1], pool: false)
  end
end
