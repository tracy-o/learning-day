defmodule Belfrage.AWS.HttpClient do
  alias Belfrage.Clients.HTTP

  @http_client Application.get_env(:belfrage, :http_client, HTTP)
  @default_timeout Application.get_env(:belfrage, :default_timeout)

  @behaviour ExAws.Request.HttpClient

  @impl ExAws.Request.HttpClient
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    @http_client.execute(
      HTTP.Request.new(%{
        method: method,
        url: url,
        payload: body,
        timeout: Keyword.get(http_opts, :timeout, @default_timeout),
        headers: headers
      }),
      Keyword.get(http_opts, :pool_name, :AWS)
    )
  end
end
