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
        {"x-candy-audience", "1"},
        {"x-candy-override", "1"},
        {"x-candy-preview-guid", "1"},
        {"x-morph-env", "1"},
        {"x-use-fixture", "1"},
        {"cookie-ckps_language", "1"},
        {"cookie-ckps_chinese", "1"},
        {"cookie-ckps_serbian", "1"},
        {"origin", "https://www.test.bbc.co.uk"},
        {"referer", "https://www.test.bbc.co.uk/page"},
        {"user-agent", "MozartFetcher"}
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
                 x_candy_audience: %{x_candy_audience: "1"},
                 x_candy_override: %{x_candy_override: "1"},
                 x_candy_preview_guid: %{x_candy_preview_guid: "1"},
                 x_morph_env: %{x_morph_env: "1"},
                 x_use_fixture: %{x_use_fixture: "1"},
                 cookie_ckps_language: %{cookie_ckps_language: "1"},
                 cookie_ckps_chinese: %{cookie_ckps_chinese: "1"},
                 cookie_ckps_serbian: %{cookie_ckps_serbian: "1"},
                 origin: %{origin: "https://www.test.bbc.co.uk"},
                 referer: %{referer: "https://www.test.bbc.co.uk/page"},
                 user_agent: %{user_agent: "MozartFetcher"}
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
        {"x-candy-audience", ""},
        {"x-candy-override", ""},
        {"x-candy-preview-guid", ""},
        {"x-morph-env", ""},
        {"x-use-fixture", ""},
        {"cookie-ckps_language", ""},
        {"cookie-ckps_chinese", ""},
        {"cookie-ckps_serbian", ""},
        {"origin", ""},
        {"referer", ""},
        {"user_agent", ""}
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
    end
  end
end
