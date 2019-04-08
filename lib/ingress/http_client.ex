defmodule Ingress.HTTPClient do
  @callback get(String.t(), String.t()) :: HTTPoison.Response
  @callback get(String.t(), String.t(), List.t()) :: HTTPoison.Response
  @callback get(String.t(), String.t(), List.t(), Keyword.t()) :: HTTPoison.Response

  @callback post(String.t(), String.t(), Map.t()) :: HTTPoison.Response
  @callback post(String.t(), String.t(), Map.t(), List.t()) :: HTTPoison.Response
  @callback post(String.t(), String.t(), Map.t(), List.t(), Keyword.t()) :: HTTPoison.Response

  def get(host, path, headers \\ [], options \\ [])
      when is_binary(host) and is_binary(path) and is_list(headers) do
    HTTPoison.get(host <> path, headers, options)
  end

  def post(host, path, body, headers \\ [], options \\ [])
      when is_binary(host) and is_binary(path) and is_binary(body) and is_list(headers) do
    HTTPoison.post(host <> path, body, headers, options)
  end
end
