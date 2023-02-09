defmodule BelfrageWeb.Response.Headers.Via do
  require Logger
  import Plug.Conn

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, envelope) do
    put_resp_header(conn, "via", append_to_via(build_via(conn), Map.get(envelope.response.headers, "via")))
  end

  defp build_via(conn) do
    "#{protocol_version(Plug.Conn.get_http_protocol(conn))} Belfrage"
  end

  defp append_to_via(belfrage_via, _existing_via = nil), do: belfrage_via

  defp append_to_via(belfrage_via, existing_via) do
    existing_via <> ", " <> belfrage_via
  end

  defp protocol_version(:"HTTP/1"), do: "1"
  defp protocol_version(:"HTTP/1.0"), do: "1.0"
  defp protocol_version(:"HTTP/1.1"), do: "1.1"
  defp protocol_version(:"HTTP/2"), do: "2"

  defp protocol_version(protocol) do
    Logger.log(:info, "No match for #{protocol} protocol. Match to increase performance.")

    protocol
    |> Atom.to_string()
    |> String.replace_prefix("HTTP/", "")
  end
end
