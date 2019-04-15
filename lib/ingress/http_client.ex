defmodule Ingress.HTTPClient do
  @callback get(String.t(), String.t()) :: HTTPoison.Response
  @callback get(String.t(), String.t(), List.t()) :: HTTPoison.Response
  @callback get(String.t(), String.t(), List.t(), Keyword.t()) :: HTTPoison.Response

  @callback post(String.t(), String.t(), Map.t()) :: HTTPoison.Response
  @callback post(String.t(), String.t(), Map.t(), List.t()) :: HTTPoison.Response
  @callback post(String.t(), String.t(), Map.t(), List.t(), Keyword.t()) :: HTTPoison.Response

  @timeout 1_000

  def get(host, path, headers \\ [], options \\ []) do
    HTTPoison.get(host <> path, headers, build_options(options))
  end

  def post(host, path, body, headers \\ [], options \\ []) when is_binary(body) do
    HTTPoison.post(host <> path, body, headers, build_options(options))
  end

  defp build_options(options) do
    Keyword.merge([recv_timeout: @timeout, hackney: [pool: :origin_pool]], options)
  end
end
