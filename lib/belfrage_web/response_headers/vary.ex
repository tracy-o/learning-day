defmodule BelfrageWeb.ResponseHeaders.Vary do
  import Plug.Conn

  alias BelfrageWeb.Behaviours.ResponseHeaders
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private, UserSession}

  @behaviour ResponseHeaders

  @impl ResponseHeaders
  def add_header(conn, struct = %Struct{request: request}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(struct, request.cdn?)
    )
  end

  def vary_headers(struct, cdn?)

  def vary_headers(%Struct{request: request = %Request{}, private: private = %Private{headers_allowlist: []}}, false) do
    request
    |> base_headers()
    |> Kernel.++(adverts_headers(request.edge_cache?, private.platform))
    |> Enum.join(",")
  end

  def vary_headers(struct = %Struct{request: request = %Request{}, private: private = %Private{}}, false) do
    request
    |> base_headers()
    |> Kernel.++(allowed_headers(struct))
    |> Kernel.++(adverts_headers(request.edge_cache?, private.platform))
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
  defp allowed_headers(%Struct{private: private = %Private{}, user_session: user_session = %UserSession{}}) do
    ignore_headers =
      if user_session.authenticated && !private.personalised_request do
        ~w(cookie x-id-oidc-signedin)
      else
        ~w(cookie)
      end

    private.headers_allowlist -- ignore_headers
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
