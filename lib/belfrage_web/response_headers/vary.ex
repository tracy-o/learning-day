defmodule BelfrageWeb.ResponseHeaders.Vary do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders
  alias Belfrage.Struct

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{request: request, private: private}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(request, private, request.cdn?)
    )
  end

  def vary_headers(request, private, false) do
    [
      "Accept-Encoding",
      "X-BBC-Edge-Cache",
      country(edge_cache: request.edge_cache?),
      is_uk(request.edge_cache?),
      "X-BBC-Edge-Scheme",
      additional_headers(private.headers_allowlist)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(",")
  end

  def vary_headers(_request, _private, true) do
    "Accept-Encoding"
  end

  def country(edge_cache: true), do: "X-BBC-Edge-Country"
  def country(edge_cache: false), do: "X-Country"

  def is_uk(true), do: "X-BBC-Edge-IsUK"
  def is_uk(false), do: "X-IP_Is_UK_Combined"

  defp additional_headers(allowed_headers) when allowed_headers == [], do: nil

  defp additional_headers(allowed_headers) do
    allowed_headers
    |> Enum.join(",")
  end
end
