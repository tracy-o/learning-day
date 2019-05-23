defmodule Ingress.Clients.Lambda do
  use ExMetrics
  @behaviour ExAws.Request.HttpClient

  @callback call(String.t(), String.t(), String.t(), Ingress.Struct.Request.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    Mojito.request(method, url, headers, body, opts: http_opts ++ [protocols: [:http1], pool: false])
  end

  def call(role_name, arn, function, request) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      with {:ok, %{body: credentials}} <- assume_role(arn, role_name) do
        invoke_lambda(function, request, credentials)
      else
        {:error, reason} ->
          Stump.log(:error, %{message: "Failed to assume role", reason: reason})
          ExMetrics.increment("clients.lambda.assume_role_failure")
          {500, "Failed to assume role"}
      end
    end
  end

  defp assume_role(arn, role_name) do
    ExAws.STS.assume_role(arn, role_name)
    |> ExAws.request()
  end

  defp invoke_lambda(function, request, credentials) do
    with {:ok, body} <-
           ExAws.Lambda.invoke(function, request, %{})
           |> ExAws.request(
             security_token: credentials.session_token,
             access_key_id: credentials.access_key_id,
             secret_access_key: credentials.secret_access_key
           ) do
      {200, body}
    else
      {:error, reason} ->
        Stump.log(:error, %{message: "Failed to Invoke Lambda", reason: reason})
        ExMetrics.increment("clients.lambda.invoke_failure")
        {500, "Failed to Invoke Lambda"}
    end
  end
end
