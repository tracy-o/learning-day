defmodule Ingress.HTTPClient do
  @callback get(String.t(), String.t()) :: Mojito.Response
  @callback get(String.t(), String.t(), List.t()) :: Mojito.Response
  @callback get(String.t(), String.t(), List.t(), Keyword.t()) :: Mojito.Response

  @callback post(String.t(), String.t(), Map.t()) :: Mojito.Response
  @callback post(String.t(), String.t(), Map.t(), List.t()) :: Mojito.Response
  @callback post(String.t(), String.t(), Map.t(), List.t(), Keyword.t()) :: Mojito.Response

  @timeout 1_000

  def get(host, path, headers \\ [], options \\ []) do
    Mojito.request(:get, host <> path, headers, "", build_options(options))
  end

  def post(host, path, body, headers \\ [], options \\ []) when is_binary(body) do
    Mojito.request(:post, host <> path, headers, body, build_options(options))
  end

  defp build_options(options) do
    Keyword.merge([timeout: @timeout], options)
  end
end
