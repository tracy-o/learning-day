defmodule Fixtures.Struct do
  alias Belfrage.Struct

  def struct_with_gzip_resp(), do: struct_with_gzip_resp(%Struct{})

  def struct_with_gzip_resp(struct, body \\ "{\"hello\":\"world\"}") do
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
end
