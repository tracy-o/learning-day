defmodule BelfrageWeb.RequestHeaders.Mapper do
  @map %{
    cache: %{edge: "x-bbc-edge-cache"},
    cdn: %{http: "x-bbc-edge-cdn"},
    country: %{edge: "x-bbc-edge-country", varnish: "x-country"},
    host: %{edge: "x-bbc-edge-host", forwarded: "x-forwarded-host", http: "host"},
    is_uk: %{varnish: "x-ip_is_uk_combined"},
    is_advertise: %{varnish: "x-ip_is_advertise_combined"},
    scheme: %{edge: "x-bbc-edge-scheme"},
    replayed_traffic: %{replayed_traffic: "replayed-traffic"},
    origin_simulator: %{origin_simulator: "origin-simulator"},
    req_svc_chain: %{req_svc_chain: "req-svc-chain"},
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

  @empty %{
    cache: %{edge: nil},
    cdn: %{http: nil},
    country: %{edge: nil, varnish: nil},
    host: %{edge: nil, forwarded: nil, http: nil},
    is_uk: %{edge: nil, varnish: nil},
    is_advertise: %{edge: nil, varnish: nil},
    replayed_traffic: %{replayed_traffic: nil},
    origin_simulator: %{origin_simulator: nil},
    scheme: %{edge: nil},
    req_svc_chain: %{req_svc_chain: nil},
    x_candy_audience: %{x_candy_audience: nil},
    x_candy_override: %{x_candy_override: nil},
    x_candy_preview_guid: %{x_candy_preview_guid: nil},
    x_morph_env: %{x_morph_env: nil},
    x_use_fixture: %{x_use_fixture: nil},
    cookie_ckps_language: %{cookie_ckps_language: nil},
    cookie_ckps_chinese: %{cookie_ckps_chinese: nil},
    cookie_ckps_serbian: %{cookie_ckps_serbian: nil},
    origin: %{origin: nil},
    referer: %{referer: nil},
    user_agent: %{user_agent: nil}
  }

  def map([{}]) do
    @empty
  end

  def map(req_headers) do
    req_headers
    |> Enum.reduce(@empty, fn {name, value}, acc ->
      map_header(acc, name, value)
    end)
  end

  for {key0, mapping} <- @map do
    for {key1, name} <- mapping do
      defp map_header(acc, unquote(name), value) do
        Map.update(acc, unquote(key0), %{}, fn prev -> Map.put(prev, unquote(key1), empty(value)) end)
      end
    end
  end

  # This is a special case because the header results in two entries
  # in the returned map and we can only have one function clause which
  # matches it. So we either change the representation of the `@map'
  # above to make generating the function clause possible, or we treat
  # it as a special case.
  defp map_header(acc, "x-bbc-edge-isuk", value) do
    acc
    |> put_in([:is_uk, :edge], empty(value))
    |> put_in([:is_advertise, :edge], empty(value))
  end

  defp map_header(acc, _name, _value) do
    acc
  end

  defp empty(""), do: nil
  defp empty(val), do: val
end
