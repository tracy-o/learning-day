defmodule BelfrageWeb.Response.Headers.VaryTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias BelfrageWeb.Response.Headers.Vary
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private, UserSession}

  describe "Country Header" do
    test "When the cache header is set it varies on X-BBC-Edge-Country" do
      struct = %Struct{request: %Request{edge_cache?: true}}

      assert vary_header(struct) ==
               "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"
    end

    test "When the cache header isnt set it varies on X-Country" do
      struct = %Struct{request: %Request{edge_cache?: false}}
      assert vary_header(struct) == "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
    end
  end

  describe "Reduced Vary Header - when serving through CDN" do
    test "When the request is from a CDN it only varies on Accept-Encoding" do
      struct = %Struct{request: %Request{cdn?: true}}
      assert vary_header(struct) == "Accept-Encoding"
    end
  end

  describe "is_uk" do
    test "when the request is from the edge then it varies on x-bbc-edge-isuk" do
      struct = %Struct{request: %Request{edge_cache?: true}}

      assert vary_header(struct) ==
               "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"
    end

    test "when the request is not from the edge then it varies on x-ip_is_uk_combined" do
      struct = %Struct{request: %Request{edge_cache?: false}}
      assert vary_header(struct) == "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
    end
  end

  describe "route headers" do
    test "varies on a provided route header, when cdn is false" do
      struct = %Struct{private: %Private{headers_allowlist: ["one_header"]}}
      assert "one_header" in vary_headers(struct)
    end

    test "varies on provided route headers, when cdn is false" do
      struct = %Struct{
        private: %Private{headers_allowlist: ["one_header", "another_header", "more_header"]}
      }

      headers = vary_headers(struct)
      assert "one_header" in headers
      assert "another_header" in headers
      assert "more_header" in headers
    end

    test "does not vary on route headers, when cdn is true" do
      struct = %Struct{request: %Request{cdn?: true}, private: %{headers_allowlist: ["one_header", "another_header"]}}
      headers = vary_headers(struct)
      refute "one_header" in headers
      refute "another_header" in headers
    end

    test "never vary on cookie" do
      struct = %Struct{private: %Private{headers_allowlist: ["cookie"]}}
      refute "cookie" in vary_headers(struct)
    end

    test "vary personalised requests on x-id-oidc-signedin" do
      struct = %Struct{
        request: %Request{host: "bbc.co.uk"},
        private: %Private{headers_allowlist: ["x-id-oidc-signedin"], personalised_request: true}
      }

      assert "x-id-oidc-signedin" in vary_headers(struct)
    end

    test "vary requests to personalised routes on x-id-oidc-signedin if personalisation is enabled" do
      enable_personalisation()

      struct = %Struct{
        request: %Request{host: "bbc.co.uk"},
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"],
          personalised_route: true
        }
      }

      assert "x-id-oidc-signedin" in vary_headers(struct)
    end

    test "don't vary requests to personalised routes on x-id-oidc-signedin if personalisation is disabled" do
      disable_personalisation()

      struct = %Struct{
        request: %Request{host: "bbc.co.uk"},
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"],
          personalised_route: true
        },
        user_session: %UserSession{authenticated: true}
      }

      refute "x-id-oidc-signedin" in vary_headers(struct)
    end

    test "don't vary requests to personalised routes on x-id-oidc-signedin if host is bbc.com" do
      struct = %Struct{
        request: %Request{
          host: "bbc.com"
        },
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"],
          personalised_route: true
        }
      }

      refute "x-id-oidc-signedin" in vary_headers(struct)
    end
  end

  describe "advertise headers" do
    test "varies on X-Ip_is_advertise_combined when platform is Simorgh and request not edge cache" do
      struct = %Struct{request: %Request{edge_cache?: false}, private: %Private{platform: Simorgh}}
      assert "X-Ip_is_advertise_combined" in vary_headers(struct)
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Simorgh and request edge cache" do
      struct = %Struct{request: %Request{edge_cache?: true}, private: %Private{platform: Simorgh}}
      refute "X-Ip_is_advertise_combined" in vary_headers(struct)
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Webcore and request not edge cache" do
      struct = %Struct{request: %Request{edge_cache?: false}, private: %Private{platform: Webcore}}
      refute "X-Ip_is_advertise_combined" in vary_headers(struct)
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Webcore and request edge cache" do
      struct = %Struct{request: %Request{edge_cache?: true}, private: %Private{platform: Webcore}}
      refute "X-Ip_is_advertise_combined" in vary_headers(struct)
    end
  end

  defp vary_header(struct) do
    conn(:get, "/") |> Vary.add_header(struct) |> get_resp_header("vary") |> hd()
  end

  defp vary_headers(struct) do
    struct |> vary_header() |> String.split(",")
  end
end