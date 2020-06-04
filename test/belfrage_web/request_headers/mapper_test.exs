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
                 replayed_traffic: %{replayed_traffic: nil},
                 scheme: %{edge: nil},
                 varnish: %{varnish: nil},
                 req_svc_chain: %{req_svc_chain: nil}
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
        {"replayed-traffic", "true"},
        {"varnish", ""},
        {"req-svc-chain", "SomeTrafficManager"}
      ]

      assert Mapper.map(req_headers) ==
               %{
                 cache: %{edge: "1"},
                 cdn: %{http: "1"},
                 country: %{edge: "**", varnish: "gb"},
                 host: %{edge: nil, forwarded: nil, http: nil},
                 is_uk: %{edge: "yes", varnish: "yes"},
                 replayed_traffic: %{replayed_traffic: "true"},
                 scheme: %{edge: nil},
                 varnish: %{varnish: nil},
                 req_svc_chain: %{req_svc_chain: "SomeTrafficManager"}
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
        {"varnish", ""},
        {"req-svc-chain", ""}
      ]

      assert Mapper.map(req_headers) ==
               %{
                 cache: %{edge: nil},
                 cdn: %{http: nil},
                 country: %{edge: nil, varnish: nil},
                 host: %{edge: nil, forwarded: nil, http: nil},
                 is_uk: %{edge: nil, varnish: nil},
                 replayed_traffic: %{replayed_traffic: nil},
                 scheme: %{edge: nil},
                 varnish: %{varnish: nil},
                 req_svc_chain: %{req_svc_chain: nil}
               }
    end
  end
end
