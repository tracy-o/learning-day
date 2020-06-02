defmodule BelfrageWeb.ResponseHeaders.Vary do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders
  alias Belfrage.Struct

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, %Struct{request: request}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(request, request.cdn?)
    )
  end

  def vary_headers(request, false) do
    [
      "Accept-Encoding",
      "X-BBC-Edge-Cache",
      country(edge_cache: request.edge_cache?, varnish: request.varnish?),
      is_uk(request.edge_cache?),
      "X-BBC-Edge-Scheme",
      language_cookie(request.path),
      raw_headers(request.raw_headers)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  def vary_headers(_, true) do
    "Accept-Encoding"
  end

  def country(edge_cache: true, varnish: _), do: "X-BBC-Edge-Country"
  def country(edge_cache: false, varnish: true), do: "X-Country"
  def country(edge_cache: false, varnish: false), do: nil

  def is_uk(true), do: "X-BBC-Edge-IsUK"
  def is_uk(false), do: "X-IP_Is_UK_Combined"

  defp language_cookie("/weather" <> _rest), do: "X-Cookie-ckps_language"
  defp language_cookie("/ukchina" <> _rest), do: "X-Cookie-ckps_chinese"
  defp language_cookie("/zhongwen" <> _rest), do: "X-Cookie-ckps_chinese"
  defp language_cookie("/serbian" <> _rest), do: "X-Cookie-ckps_serbian"
  defp language_cookie(_path), do: nil

  defp raw_headers(raw_headers) when raw_headers == %{}, do: nil
  defp raw_headers(raw_headers) do
    raw_headers
    |> Map.keys()
    |> Enum.join(", ")
  end
end
