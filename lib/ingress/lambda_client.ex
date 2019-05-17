defmodule Ingress.LambdaClient do
  @callback request(String.t(), String.t(), List.t(), Keyword.t()) :: Mojito.Response
  @timeout 1_000

  @behaviour ExAws.Request.HttpClient
  def request(method, url, body \\ nil, headers \\ [], options \\ []) do
    IO.puts("In")
    {:ok,
     Mojito.request(method, url, body: body, headers: headers, ibrowse: [headers_as_is: true], opts: build_options(options))}
  end

  defp build_options(options) do
    Keyword.merge([timeout: @timeout], options)
  end
end
