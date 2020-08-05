defmodule BelfrageWeb.ResponseHeaders.Via do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct) do
    put_resp_header(conn, "via", append_to_via(build_via(conn), Map.get(struct.response.headers, "via")))
  end

  defp build_via(conn) do
    "#{protocol_version(Plug.Conn.get_http_protocol(conn))} Belfrage"
  end

  defp append_to_via(belfrage_via, _existing_via = nil), do: belfrage_via

  defp append_to_via(belfrage_via, existing_via) do
    existing_via <> ", " <> belfrage_via
  end

  defp protocol_version(:"HTTP/1"), do: "1"
  defp protocol_version(:"HTTP/1.1"), do: "1.1"
  defp protocol_version(:"HTTP/2"), do: "2"
  defp protocol_version(protocol) do
    Belfrage.Event.record(:log, :info, "No match for #{protocol} protocol. Match to increase performance.")

    protocol
    |> Atom.to_string()
    |> String.replace_prefix("HTTP/", "")
  end
end
