defmodule Ingress.Clients.Lambda do
  use ExMetrics
  @behaviour ExAws.Request.HttpClient

  @callback call(String.t(), String.t(), String.t(), Ingress.Struct.Request.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    Mojito.request(method, url, headers, body, build_options(http_opts))
  end

  def call(role_name, arn, function, payload) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      with {:ok, %{body: credentials}} <- assume_role(arn, role_name) do
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
    ExAws.STS.assume_role(arn, role_name)
    |> ExAws.request()
  end

  defp invoke_lambda(function, payload, credentials) do
    with {:ok, body} <-
           ExAws.Lambda.invoke(function, payload, %{})
           |> ExAws.request(
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
    Keyword.merge(opts, protocols: [:http1], pool: false)
  end
end
