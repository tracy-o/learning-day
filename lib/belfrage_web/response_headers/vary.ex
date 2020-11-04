defmodule BelfrageWeb.ResponseHeaders.Vary do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @behaviour ResponseHeaders

  # TODO: to be removed and made explicit via DSL in RESFRAME-3924
  @disallow_headers ["cookie"]

  @impl ResponseHeaders
  def add_header(conn, %Struct{request: request, private: private}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(request, private, request.cdn?)
    )
  end

  def vary_headers(request, private, cdn?)

  def vary_headers(request, %Private{headers_allowlist: []}, false) do
    base_headers(request) |> IO.iodata_to_binary()
  end

  def vary_headers(request, %Private{headers_allowlist: list}, false) do
    [base_headers(request), allow_headers(list)] |> IO.iodata_to_binary()
  end

  def vary_headers(_request, _private, true), do: "Accept-Encoding"

  def disallow_headers(), do: @disallow_headers

  defp base_headers(request) do
    [
      "Accept-Encoding",
      ?,,
      "X-BBC-Edge-Cache",
      ?,,
      country(edge_cache: request.edge_cache?),
      ?,,
      is_uk(request.edge_cache?),
      ?,,
      "X-BBC-Edge-Scheme"
    ]
  end

  defp allow_headers(headers)
  defp allow_headers([]), do: []
  defp allow_headers([header | rest]) when header in @disallow_headers, do: allow_headers(rest)
  defp allow_headers([header | rest]), do: [?,, header, allow_headers(rest)]

  defp country(edge_cache: true), do: "X-BBC-Edge-Country"
  defp country(edge_cache: false), do: "X-Country"

  defp is_uk(true), do: "X-BBC-Edge-IsUK"
  defp is_uk(false), do: "X-IP_Is_UK_Combined"
end
