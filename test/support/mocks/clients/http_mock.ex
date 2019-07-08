defmodule Belfrage.Clients.HTTPMock do
  @behaviour Belfrage.Clients.HTTP
  alias Belfrage.Clients.HTTP

  @generic_response {:ok,
                     %Mojito.Response{
                       status_code: 200,
                       headers: [{"content-type", "application/json"}],
                       body: "{}"
                     }}

  @impl HTTP
  def get(_host, _path, _headers \\ [], _options \\ []), do: @generic_response
  @impl HTTP
  def post(_host, _path, _body, _headers \\ [], _options \\ []), do: @generic_response
end
