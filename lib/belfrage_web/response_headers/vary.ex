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
      vary_headers(request)
    )
  end

  def vary_headers(request) do
    [
      "Accept-Encoding",
      "X-BBC-Edge-Cache",
      country(edge_cache: request.edge_cache?, varnish: request.varnish?),
      "X-BBC-Edge-Scheme"
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  def country(edge_cache: true, varnish: _), do: "X-BBC-Edge-Country"
  def country(edge_cache: false, varnish: true), do: "X-Country"
  def country(edge_cache: false, varnish: false), do: nil
end
