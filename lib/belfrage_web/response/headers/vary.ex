defmodule BelfrageWeb.Response.Headers.Vary do
  import Plug.Conn

  alias Belfrage.Struct
  alias Belfrage.Struct.Private
  alias Belfrage.Personalisation
  alias Belfrage.Language

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, struct = %Struct{request: request}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(struct, request.cdn?)
    )
  end

  def vary_headers(struct, cdn?)

  def vary_headers(struct = %Struct{}, false) do
    edge_cache? = struct.request.edge_cache?
    platform = struct.private.platform

    struct.request
    |> base_headers()
    |> Kernel.++(route_headers(struct))
    |> Kernel.++(adverts_headers(edge_cache?, platform))
    |> Enum.join(",")
  end

  def vary_headers(_struct, true), do: "Accept-Encoding"

  defp base_headers(request) do
    [
      "Accept-Encoding",
      "X-BBC-Edge-Cache",
      country(edge_cache: request.edge_cache?),
      is_uk(request.edge_cache?),
      "X-BBC-Edge-Scheme"
    ]
  end

  # TODO: to be improved in RESFRAME-3924
  defp route_headers(struct = %Struct{private: %Private{headers_allowlist: []}}) do
    Language.vary([], struct)
  end

  defp route_headers(struct = %Struct{private: %Private{headers_allowlist: allowlist}}) do
    allowlist
    |> List.delete("cookie")
    |> remove_signed_in_header(struct)
    |> Language.vary(struct)
  end

  defp remove_signed_in_header(headers, %Struct{request: request, private: private = %Private{}}) do
    if private.personalised_route && !(Personalisation.applicable_request?(request) && Personalisation.enabled?()) do
      List.delete(headers, "x-id-oidc-signedin")
    else
      headers
    end
  end

  # TODO Remove duplication of headers - so commenting out for now
  # TODO Sort headers and also allow these to be specified as part of route/platform
  # defp adverts_headers(true, :"Elixir.Simorgh"), do: "X-BBC-Edge-IsUK"
  defp adverts_headers(false, :"Elixir.Simorgh"), do: ["X-Ip_is_advertise_combined"]
  defp adverts_headers(_, _), do: []

  defp country(edge_cache: true), do: "X-BBC-Edge-Country"
  defp country(edge_cache: false), do: "X-Country"

  defp is_uk(true), do: "X-BBC-Edge-IsUK"
  defp is_uk(false), do: "X-IP_Is_UK_Combined"
end
