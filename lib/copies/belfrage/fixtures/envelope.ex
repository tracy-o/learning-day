defmodule Fixtures.Envelope do
  alias Belfrage.Envelope

  def envelope_with_gzip_resp(), do: envelope_with_gzip_resp(%Envelope{})

  def envelope_with_gzip_resp(envelope, body \\ "{\"hello\":\"world\"}") when is_binary(body) do
    Envelope.add(
      envelope,
      :response,
      %{
        body: :zlib.zip(body),
        headers: %{
          "content-encoding" => "gzip"
        }
      }
    )
  end

  def envelope_with_resp(envelope, lambda) when is_map(lambda), do: Envelope.add(envelope, :response, lambda)

  def request_envelope(scheme, host, path, query \\ %{}, path_params \\ %{}) do
    %Envelope{
      request: %Envelope.Request{
        scheme: scheme,
        host: host,
        path: path,
        path_params: path_params,
        query_params: query
      }
    }
  end

  def successful_response() do
    %Belfrage.Envelope.Response{
      body: "hello!",
      headers: %{"content-type" => "application/json"},
      http_status: 200,
      cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
      cache_last_updated: Belfrage.Timer.now_ms()
    }
  end
end
