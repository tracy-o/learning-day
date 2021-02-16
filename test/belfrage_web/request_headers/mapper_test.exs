defmodule BelfrageWeb.RequestHeaders.MapperTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.RequestHeaders.Mapper

  describe "headers mapper" do
    test "returns headers map when no request headers are set" do
      assert Mapper.map([{}]) ==
               %{
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
                 x_cdn: %{x_cdn: nil},
                 x_candy_audience: %{x_candy_audience: nil},
                 x_candy_override: %{x_candy_override: nil},
                 x_candy_preview_guid: %{x_candy_preview_guid: nil},
                 x_morph_env: %{x_morph_env: nil},
                 x_use_fixture: %{x_use_fixture: nil},
                 cookie_cps_language: %{cookie_cps_language: nil},
                 cookie_cps_chinese: %{cookie_cps_chinese: nil},
                 cookie_cps_serbian: %{cookie_cps_serbian: nil},
                 origin: %{origin: nil},
                 referer: %{referer: nil}
               }
    end

    test "returns headers map with interpolated values where request headers exist" do
      req_headers = [
        {"x-bbc-edge-cache", "1"},
        {"x-bbc-edge-cdn", "1"},
        {"x-bbc-edge-country", "**"},
        {"x-bbc-edge-isuk", "yes"},
        {"x-country", "gb"},
        {"x-ip_is_uk_combined", "yes"},
        {"x-ip_is_advertise_combined", "yes"},
        {"replayed-traffic", "true"},
        {"origin-simulator", "true"},
        {"req-svc-chain", "SomeTrafficManager"},
        {"x-cdn", "1"},
        {"x-candy-audience", "1"},
        {"x-candy-override", "1"},
        {"x-candy-preview-guid", "1"},
        {"x-morph-env", "1"},
        {"x-use-fixture", "1"},
        {"cookie-cps-language", "1"},
        {"cookie-cps-chinese", "1"},
        {"cookie-cps-serbian", "1"},
        {"origin", "https://www.test.bbc.co.uk"},
        {"referer", "https://www.test.bbc.co.uk/page"}
      ]

      assert Mapper.map(req_headers) ==
               %{
                 cache: %{edge: "1"},
                 cdn: %{http: "1"},
                 country: %{edge: "**", varnish: "gb"},
                 host: %{edge: nil, forwarded: nil, http: nil},
                 is_uk: %{edge: "yes", varnish: "yes"},
                 is_advertise: %{edge: "yes", varnish: "yes"},
                 replayed_traffic: %{replayed_traffic: "true"},
                 origin_simulator: %{origin_simulator: "true"},
                 scheme: %{edge: nil},
                 req_svc_chain: %{req_svc_chain: "SomeTrafficManager"},
                 x_cdn: %{x_cdn: "1"},
                 x_candy_audience: %{x_candy_audience: "1"},
                 x_candy_override: %{x_candy_override: "1"},
                 x_candy_preview_guid: %{x_candy_preview_guid: "1"},
                 x_morph_env: %{x_morph_env: "1"},
                 x_use_fixture: %{x_use_fixture: "1"},
                 cookie_cps_language: %{cookie_cps_language: "1"},
                 cookie_cps_chinese: %{cookie_cps_chinese: "1"},
                 cookie_cps_serbian: %{cookie_cps_serbian: "1"},
                 origin: %{origin: "https://www.test.bbc.co.uk"},
                 referer: %{referer: "https://www.test.bbc.co.uk/page"}
               }
    end

    test "returns headers map with empty strings converted to nil" do
      req_headers = [
        {"x-bbc-edge-cache", ""},
        {"x-bbc-edge-cdn", ""},
        {"x-bbc-edge-country", ""},
        {"x-country", ""},
        {"x-bbc-edge-isuk", ""},
        {"replayed-traffic", ""},
        {"origin-simulator", ""},
        {"req-svc-chain", ""},
        {"x-cdn", ""},
        {"x-candy-audience", ""},
        {"x-candy-override", ""},
        {"x-candy-preview-guid", ""},
        {"x-morph-env", ""},
        {"x-use-fixture", ""},
        {"cookie-cps-language", ""},
        {"cookie-cps-chinese", ""},
        {"cookie-cps-serbian", ""},
        {"origin", ""},
        {"referer", ""}
      ]

      assert Mapper.map(req_headers) ==
               %{
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
                 x_cdn: %{x_cdn: nil},
                 x_candy_audience: %{x_candy_audience: nil},
                 x_candy_override: %{x_candy_override: nil},
                 x_candy_preview_guid: %{x_candy_preview_guid: nil},
                 x_morph_env: %{x_morph_env: nil},
                 x_use_fixture: %{x_use_fixture: nil},
                 cookie_cps_language: %{cookie_cps_language: nil},
                 cookie_cps_chinese: %{cookie_cps_chinese: nil},
                 cookie_cps_serbian: %{cookie_cps_serbian: nil},
                 origin: %{origin: nil},
                 referer: %{referer: nil}
               }
    end
  end
end
