defmodule Ingress.LambdaClientMock do
  # @behaviour Ingress.LambdaClient
  # alias Ingress.LambdaClient

  # @generic_response {:ok,
  #                    %Mojito.Response{
  #                      status_code: 200,
  #                      headers: [{"content-type", "application/json"}],
  #                      body: "{}"
  #                    }}

  # @impl LambdaClient
  # def request(_method, _path, _headers \\ [], _options \\ []), do: @generic_response

  @impl Ingress.LambdaClient
  def request(method, url, body \\ nil, headers \\ [], options \\ []) do
    IO.puts("In")
    {}
  end
end
