defmodule BelfrageWeb.RequestHeaders.Mapper do
  @map %{
    cache: %{edge: "x-bbc-edge-cache"},
    cdn: %{http: "x-bbc-edge-cdn"},
    country: %{edge: "x-bbc-edge-country", varnish: "x-country"},
    host: %{edge: "x-bbc-edge-host", forwarded: "x-forwarded-host", http: "host"},
    is_uk: %{edge: "x-bbc-edge-isuk", varnish: "x-ip_is_uk_combined"},
    is_advertise: %{edge: "x-bbc-edge-isuk", varnish: "x-ip_is_advertise_combined"},
    scheme: %{edge: "x-bbc-edge-scheme"},
    replayed_traffic: %{replayed_traffic: "replayed-traffic"},
    origin_simulator: %{origin_simulator: "origin-simulator"},
    req_svc_chain: %{req_svc_chain: "req-svc-chain"},
    x_cdn: %{x_cdn: "x-cdn"},
    x_candy_audience: %{x_candy_audience: "x-candy-audience"},
    x_candy_override: %{x_candy_override: "x-candy-override"},
    x_candy_preview_guid: %{x_candy_preview_guid: "x-candy-preview-guid"},
    x_morph_env: %{x_morph_env: "x-morph-env"},
    x_use_fixture: %{x_use_fixture: "x-use-fixture"},
    cookie_ckps_language: %{cookie_ckps_language: "cookie-ckps_language"},
    cookie_ckps_chinese: %{cookie_ckps_chinese: "cookie-ckps_chinese"},
    cookie_ckps_serbian: %{cookie_ckps_serbian: "cookie-ckps_serbian"},
    origin: %{origin: "origin"},
    referer: %{referer: "referer"},
    user_agent: %{user_agent: "user-agent"}
  }

  def map(req_headers) do
    Enum.into(@map, %{}, fn {header_key, headers_map} ->
      {header_key,
       Enum.into(headers_map, %{}, fn {bbc_header_from, bbc_header_key} ->
         {bbc_header_from, get_req_header(req_headers, bbc_header_key)}
       end)}
    end)
  end

  defp get_req_header(headers, _key) when headers == [{}], do: nil

  defp get_req_header(headers, key) do
    headers
    |> Enum.find({nil, nil}, fn {k, _v} -> k == key end)
    |> elem(1)
    |> empty_string_to_nil
  end

  defp empty_string_to_nil(v) when v == "", do: nil

  defp empty_string_to_nil(v), do: v
end
