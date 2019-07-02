defmodule Belfrage.Clients.Lambda do
  use ExMetrics
  @http_client Application.get_env(:ingress, :http_client, Clients.HTTP)

  @behaviour ExAws.Request.HttpClient

  @callback call(String.t(), String.t(), Belfrage.Struct.Request.t()) :: Tuple.t()

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    headers = Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
    %URI{host: host, path: path} = URI.parse(url)

    @http_client.post(host, path, headers, body, build_options(http_opts))
  end

  def build_options(opts) do
    Keyword.merge([protocols: [:http2, :http1], pool: false, timeout: 1000], opts)
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
