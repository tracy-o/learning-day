defmodule Ingress.HTTPClientMock do
  @behaviour Ingress.HTTPClient
  alias Ingress.HTTPClient

  @generic_response {:ok,
                     %Mojito.Response{
                       status_code: 200,
                       headers: [{"content-type", "application/json"}],
                       body: "{}"
                     }}

  @impl HTTPClient
  def get(_host, _path, _headers \\ [], _options \\ []), do: @generic_response
  @impl HTTPClient
  def post(_host, _path, _body, _headers \\ [], _options \\ []), do: @generic_response
end
