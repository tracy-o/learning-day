defmodule IngressWeb.Middlewares.RequestHeadersTransformer do
  import Plug.Conn

  @moduledoc """
  """

  alias IngressWeb.HeadersSanitiser
  alias IngressWeb.HeadersMapper

  def init(opts), do: opts

  def call(conn, _opts) do
    put_private(conn, :bbc_headers, bbc_headers(HeadersMapper.map(conn.req_headers)))
  end

  defp bbc_headers(req_headers) do
    cache = HeadersSanitiser.cache(req_headers[:cache], nil)
    Enum.into(req_headers, %{}, fn {k, v} -> {k, apply(HeadersSanitiser, k, [v, cache])} end)
  end
end
