defmodule BelfrageWeb.ResponseHeaders.Vary do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders
  alias Belfrage.Struct

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct = %Struct{request: request}) do
    put_resp_header(
      conn,
      "vary",
      "Accept-Encoding, X-BBC-Edge-Cache, #{varnish?(request.varnish?)}, Replayed-Traffic, X-BBC-Edge-Scheme"
    )
  end

  def varnish?(true), do: "X-Country"
  def varnish?(_), do: "X-BBC-Edge-Country"
end
