defmodule Fixtures.Struct do
  alias Belfrage.Struct

  def struct_with_gzip_resp(), do: struct_with_gzip_resp(%Struct{})

  def struct_with_gzip_resp(struct, body \\ "{\"hello\":\"world\"}") when is_binary(body) do
    Struct.add(
      struct,
      :response,
      %{
        body: :zlib.zip(body),
        headers: %{
          "content-encoding" => "gzip"
        }
      }
    )
  end

  def struct_with_resp(struct, lambda) when is_map(lambda), do: Struct.add(struct, :response, lambda)

  def request_struct(scheme, host, path, query \\ %{}, path_params \\ %{}) do
    %Struct{
      request: %Struct.Request{
        scheme: scheme,
        host: host,
        path: path,
        path_params: path_params,
        query_params: query
      }
    }
  end

  def successful_response() do
    %Belfrage.Struct.Response{
      body: "hello!",
      headers: %{"content-type" => "application/json"},
      http_status: 200,
      cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
      cache_last_updated: Belfrage.Timer.now_ms()
    }
  end
end
