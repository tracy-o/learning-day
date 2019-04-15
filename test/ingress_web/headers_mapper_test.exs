defmodule IngressWeb.HeadersMapperTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.HeadersMapper

  describe "headers mapper" do
    test "returns headers map when no request headers are set" do
      assert HeadersMapper.map([{}]) ==
               %{
                 cache: %{edge: nil},
                 country: %{edge: nil, varnish: nil},
                 host: %{edge: nil, forwarded: nil, http: nil}
               }
    end

    test "returns headers map with interpolated values where request headers exist" do
      req_headers = [
        {"x-bbc-edge-cache", "1"},
        {"x-bbc-edge-country", "**"},
        {"x-country", "gb"}
      ]

      assert HeadersMapper.map(req_headers) ==
               %{
                 cache: %{edge: "1"},
                 country: %{edge: "**", varnish: "gb"},
                 host: %{edge: nil, forwarded: nil, http: nil}
               }
    end

    test "returns headers map with empty strings converted to nil" do
      req_headers = [
        {"x-bbc-edge-cache", ""},
        {"x-bbc-edge-country", ""},
        {"x-country", ""}
      ]

      assert HeadersMapper.map(req_headers) ==
               %{
                 cache: %{edge: nil},
                 country: %{edge: nil, varnish: nil},
                 host: %{edge: nil, forwarded: nil, http: nil}
               }
    end
  end
end
