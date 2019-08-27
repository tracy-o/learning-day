defmodule BelfrageWeb.RequestHeaders.MapperTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.RequestHeaders.Mapper

  describe "headers mapper" do
    test "returns headers map when no request headers are set" do
      assert Mapper.map([{}]) ==
               %{
                 cache: %{edge: nil},
                 country: %{edge: nil, varnish: nil},
                 host: %{edge: nil, forwarded: nil, http: nil},
                 replayed_traffic: %{replayed_traffic: nil},
                 scheme: %{edge: nil},
                 varnish: %{varnish: nil}
               }
    end

    test "returns headers map with interpolated values where request headers exist" do
      req_headers = [
        {"x-bbc-edge-cache", "1"},
        {"x-bbc-edge-country", "**"},
        {"x-country", "gb"},
        {"replayed-traffic", "true"},
        {"varnish", ""}
      ]

      assert Mapper.map(req_headers) ==
               %{
                 cache: %{edge: "1"},
                 country: %{edge: "**", varnish: "gb"},
                 host: %{edge: nil, forwarded: nil, http: nil},
                 replayed_traffic: %{replayed_traffic: "true"},
                 scheme: %{edge: nil},
                 varnish: %{varnish: nil}
               }
    end

    test "returns headers map with empty strings converted to nil" do
      req_headers = [
        {"x-bbc-edge-cache", ""},
        {"x-bbc-edge-country", ""},
        {"x-country", ""},
        {"replayed-traffic", ""},
        {"varnish", ""}
      ]

      assert Mapper.map(req_headers) ==
               %{
                 cache: %{edge: nil},
                 country: %{edge: nil, varnish: nil},
                 host: %{edge: nil, forwarded: nil, http: nil},
                 replayed_traffic: %{replayed_traffic: nil},
                 scheme: %{edge: nil},
                 varnish: %{varnish: nil}
               }
    end
  end
end
