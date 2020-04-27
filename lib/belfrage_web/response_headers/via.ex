defmodule BelfrageWeb.ResponseHeaders.Via do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct) do
    put_resp_header(conn, "via", append_to_via(build_via(conn), Map.get(struct.response.headers, "via")))
  end

  defp build_via(conn) do
    "#{Plug.Conn.get_http_protocol(conn)} Belfrage"
  end

  defp append_to_via(belfrage_via, _existing_via = nil), do: belfrage_via

  defp append_to_via(belfrage_via, existing_via) do
    belfrage_via <> ", " <> existing_via
  end
end
