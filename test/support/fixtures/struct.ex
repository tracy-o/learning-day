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

  def request_struct(scheme, host, path, query \\ %{}) do
    %Struct{
      request: %Struct.Request{
        scheme: scheme,
        host: host,
        path: path,
        query_params: query
      }
    }
  end
end
