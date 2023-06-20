defmodule BelfrageWeb.Response.Headers.Vary do
  import Plug.Conn

  alias Belfrage.{Envelope, Envelope.Private, Envelope.Request, Personalisation, Language}

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, envelope = %Envelope{request: %Request{host: host, cdn?: cdn?}}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(envelope, cdn_or_polling(host, cdn?))
    )
  end

  def vary_headers(envelope, cdn?)

  def vary_headers(envelope = %Envelope{}, false) do
    edge_cache? = envelope.request.edge_cache?
    platform = envelope.private.platform

    envelope.request
    |> base_headers()
    |> Kernel.++(route_headers(envelope))
    |> Kernel.++(adverts_headers(edge_cache?, platform))
    |> Kernel.++(bbcx(envelope.private))
    |> Enum.uniq()
    |> Enum.join(",")
  end

  def vary_headers(_envelope, true), do: "Accept-Encoding"

  defp base_headers(request) do
    [
      "Accept-Encoding",
      "X-BBC-Edge-Cache",
      country(edge_cache: request.edge_cache?),
      is_uk(request.edge_cache?),
      "X-BBC-Edge-Scheme"
    ]
  end

  defp bbcx(%Private{bbcx_enabled: false}), do: []
  defp bbcx(%Private{bbcx_enabled: true}), do: ["cookie-ckns_bbccom_beta"]

  # TODO: to be improved in RESFRAME-3924
  defp route_headers(envelope = %Envelope{private: %Private{headers_allowlist: []}}) do
    Language.vary([], envelope)
  end

  defp route_headers(envelope = %Envelope{private: %Private{headers_allowlist: allowlist}}) do
    allowlist
    |> List.delete("cookie")
    |> List.delete("cookie-ckns_bbccom_beta")
    |> remove_signed_in_header(envelope)
    |> Language.vary(envelope)
  end

  defp remove_signed_in_header(headers, %Envelope{request: request, private: private = %Private{}}) do
    if private.personalised_route and Personalisation.applicable_request?(request) and
         Personalisation.enabled?(route_state_id: private.route_state_id) do
      headers
    else
      List.delete(headers, "x-id-oidc-signedin")
    end
  end

  # TODO Remove duplication of headers - so commenting out for now
  # TODO Sort headers and also allow these to be specified as part of route/platform
  # defp adverts_headers(true, "MozartSimorgh"), do: "X-BBC-Edge-IsUK"
  defp adverts_headers(false, "MozartSimorgh"), do: ["X-Ip_is_advertise_combined"]
  defp adverts_headers(false, "Simorgh"), do: ["X-Ip_is_advertise_combined"]
  defp adverts_headers(_, _), do: []

  defp country(edge_cache: true), do: "X-BBC-Edge-Country"
  defp country(edge_cache: false), do: "X-Country"

  defp is_uk(true), do: "X-BBC-Edge-IsUK"
  defp is_uk(false), do: "X-IP_Is_UK_Combined"

  defp cdn_or_polling(nil, cdn?), do: cdn?

  defp cdn_or_polling(host, cdn?) do
    String.contains?(host, "polling") || String.contains?(host, "feeds") || cdn?
  end
end
