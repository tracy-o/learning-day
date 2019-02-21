defmodule Ingress.HTTPClient do
  @timeout 1_000

  def get(_origin, service, :test) do
    {:ok, %HTTPoison.Response{body: "hello #{service}"}}
  end

  def get(origin, service, _env) when is_binary(origin) and is_binary(service) do
    headers = []
    options = [recv_timeout: @timeout]

    endpoint = origin <> service
    HTTPoison.get(endpoint, headers, options)
  end

  def post(_origin, _service, :test, _body) do
    {:ok, %HTTPoison.Response{body: "{\"data\":[]}"}}
  end

  def post(origin, service, _env, body) do
    headers = [
      "Content-Type": "application/json"
    ]

    options = [recv_timeout: @timeout]

    endpoint = origin <> service
    HTTPoison.post(endpoint, body, headers, options)
  end
end
