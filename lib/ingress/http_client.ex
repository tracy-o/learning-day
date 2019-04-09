defmodule Ingress.HTTPClient do
  @callback get(String.t(), String.t()) :: HTTPoison.Response
  @callback get(String.t(), String.t(), List.t()) :: HTTPoison.Response
  @callback get(String.t(), String.t(), List.t(), Keyword.t()) :: HTTPoison.Response

  @callback post(String.t(), String.t(), Map.t()) :: HTTPoison.Response
  @callback post(String.t(), String.t(), Map.t(), List.t()) :: HTTPoison.Response
  @callback post(String.t(), String.t(), Map.t(), List.t(), Keyword.t()) :: HTTPoison.Response

  def get(host, path, headers \\ [], options \\ []) do
    HTTPoison.get(host <> path, headers, options)
  end

  def post(host, path, body, headers \\ [], options \\ []) when is_binary(body) do
    HTTPoison.post(host <> path, body, headers, options)
  end
end
