defmodule Ingress.HTTPClient do
  @timeout 1_000

  def get(_origin, service, :test) do
    {:ok,  %HTTPoison.Response{body: "hello #{service}"}}
  end

  def get(origin, service, _env) when is_binary(origin) and is_binary(service) do
    headers = []
    options = [recv_timeout: @timeout]

    endpoint = origin <> service
    HTTPoison.get(endpoint, headers, options)
  end
end
