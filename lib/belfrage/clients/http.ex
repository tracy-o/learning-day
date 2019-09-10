defmodule Belfrage.Clients.HTTP do
  @type request_type :: :get | :post

  @callback request(:get, String.t()) :: Mojito.Response
  @callback request(:get, String.t(), Keyword.t()) :: Mojito.Response

  @callback request(:post, String.t(), String.t(), Map.t()) :: Mojito.Response
  @callback request(:post, String.t(), String.t(), Map.t(), List.t()) :: Mojito.Response

  @timeout 1_000

  def request(:get, url, options \\ []) do
    request(:get, url, "", options)
  end

  def request(method, url, body, options) do
    headers = Keyword.get(options, :headers, [])
    Mojito.request(method, url, headers, body, build_options(options))
  end

  def build_options(options) do
    Keyword.merge([timeout: @timeout], options)
  end
end
