defmodule IngressWeb.DefaultHeaders do
  @default_headers [IngressWeb.Headers.Vary]

  def add_default_headers(conn, struct) do
    Enum.reduce(@default_headers, conn, fn headers_module, output_conn ->
      apply(headers_module, :add_header, [output_conn, struct])
    end)
  end
end
