defmodule BelfrageWeb.Response.Headers.VaryTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias BelfrageWeb.Response.Headers.Vary
  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private, UserSession}

  describe "Country Header" do
    test "When the cache header is set it varies on X-BBC-Edge-Country" do
      envelope = %Envelope{request: %Request{edge_cache?: true}}

      assert vary_header(envelope) ==
               "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"
    end

    test "When the cache header isnt set it varies on X-Country" do
      envelope = %Envelope{request: %Request{edge_cache?: false}}
      assert vary_header(envelope) == "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
    end
  end

  describe "Reduced Vary Header - when serving through CDN" do
    test "When the request is from a CDN it only varies on Accept-Encoding" do
      envelope = %Envelope{request: %Request{cdn?: true}}
      assert vary_header(envelope) == "Accept-Encoding"
    end
  end

  describe "is_uk" do
    test "when the request is from the edge then it varies on x-bbc-edge-isuk" do
      envelope = %Envelope{request: %Request{edge_cache?: true}}

      assert vary_header(envelope) ==
               "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"
    end

    test "when the request is not from the edge then it varies on x-ip_is_uk_combined" do
      envelope = %Envelope{request: %Request{edge_cache?: false}}
      assert vary_header(envelope) == "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
    end
  end

  describe "route headers" do
    test "varies on a provided route header, when cdn is false" do
      envelope = %Envelope{private: %Private{headers_allowlist: ["one_header"]}}
      assert "one_header" in vary_headers(envelope)
    end

    test "varies on provided route headers, when cdn is false" do
      envelope = %Envelope{
        private: %Private{headers_allowlist: ["one_header", "another_header", "more_header"]}
      }

      headers = vary_headers(envelope)
      assert "one_header" in headers
      assert "another_header" in headers
      assert "more_header" in headers
    end

    test "does not vary on route headers, when cdn is true" do
      envelope = %Envelope{
        request: %Request{cdn?: true},
        private: %{headers_allowlist: ["one_header", "another_header"]}
      }

      headers = vary_headers(envelope)
      refute "one_header" in headers
      refute "another_header" in headers
    end

    test "does not vary on route headers, when host contains polling and cdn is true" do
      envelope = %Envelope{
        request: %Request{cdn?: true, host: "polling.test.bbc.co.uk"},
        private: %{headers_allowlist: ["one_header", "another_header"]}
      }

      headers = vary_headers(envelope)
      refute "one_header" in headers
      refute "another_header" in headers
    end

    test "does not vary on route headers, when host contains polling and cdn is false" do
      envelope = %Envelope{
        request: %Request{cdn?: false, host: "polling.test.bbc.co.uk"},
        private: %{headers_allowlist: ["one_header", "another_header"]}
      }

      headers = vary_headers(envelope)
      refute "one_header" in headers
      refute "another_header" in headers
    end

    test "does not vary on allow list request headers, when host contains feeds and cdn is true" do
      envelope = %Envelope{
        request: %Request{cdn?: true, host: "feeds.bbci.co.uk"},
        private: %{headers_allowlist: ["one_header", "another_header"]}
      }

      headers = vary_headers(envelope)
      refute "one_header" in headers
      refute "another_header" in headers
    end

    test "does not vary on allow list request headers, when host contains feeds and cdn is false" do
      envelope = %Envelope{
        request: %Request{cdn?: false, host: "feeds.bbci.co.uk"},
        private: %{headers_allowlist: ["one_header", "another_header"]}
      }

      headers = vary_headers(envelope)
      refute "one_header" in headers
      refute "another_header" in headers
    end

    test "never vary on cookie" do
      envelope = %Envelope{private: %Private{headers_allowlist: ["cookie"]}}
      refute "cookie" in vary_headers(envelope)
    end

    test "don't vary personalised requests to non-personalised routes on x-id-oidc-signedin" do
      envelope = %Envelope{
        request: %Request{host: "bbc.co.uk"},
        private: %Private{headers_allowlist: ["x-id-oidc-signedin"], personalised_request: true}
      }

      refute "x-id-oidc-signedin" in vary_headers(envelope)
    end

    test "vary requests to personalised routes on x-id-oidc-signedin if personalisation is enabled" do
      enable_personalisation()

      envelope = %Envelope{
        request: %Request{host: "bbc.co.uk"},
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"],
          personalised_route: true
        }
      }

      assert "x-id-oidc-signedin" in vary_headers(envelope)
    end

    test "don't vary requests to personalised routes on x-id-oidc-signedin if personalisation is disabled" do
      disable_personalisation()

      envelope = %Envelope{
        request: %Request{host: "bbc.co.uk"},
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"],
          personalised_route: true
        },
        user_session: %UserSession{authenticated: true}
      }

      refute "x-id-oidc-signedin" in vary_headers(envelope)
    end

    test "don't vary requests to personalised routes on x-id-oidc-signedin if host is bbc.com" do
      envelope = %Envelope{
        request: %Request{
          host: "bbc.com"
        },
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"],
          personalised_route: true
        }
      }

      refute "x-id-oidc-signedin" in vary_headers(envelope)
    end

    test "don't vary requests to non-personalised routes on x-id-oidc-signedin" do
      envelope = %Envelope{
        request: %Request{
          host: "bbc.co.uk"
        },
        private: %Private{
          headers_allowlist: ["x-id-oidc-signedin"]
        }
      }

      refute "x-id-oidc-signedin" in vary_headers(envelope)
    end
  end

  describe "advertise headers" do
    test "varies on X-Ip_is_advertise_combined when platform is MozartSimorgh and request not edge cache" do
      envelope = %Envelope{request: %Request{edge_cache?: false}, private: %Private{platform: "MozartSimorgh"}}
      assert "X-Ip_is_advertise_combined" in vary_headers(envelope)
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is MozartSimorgh and request edge cache" do
      envelope = %Envelope{request: %Request{edge_cache?: true}, private: %Private{platform: "MozartSimorgh"}}
      refute "X-Ip_is_advertise_combined" in vary_headers(envelope)
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Webcore and request not edge cache" do
      envelope = %Envelope{request: %Request{edge_cache?: false}, private: %Private{platform: "Webcore"}}
      refute "X-Ip_is_advertise_combined" in vary_headers(envelope)
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Webcore and request edge cache" do
      envelope = %Envelope{request: %Request{edge_cache?: true}, private: %Private{platform: "Webcore"}}
      refute "X-Ip_is_advertise_combined" in vary_headers(envelope)
    end
  end

  defp vary_header(envelope) do
    conn(:get, "/") |> Vary.add_header(envelope) |> get_resp_header("vary") |> hd()
  end

  defp vary_headers(envelope) do
    envelope |> vary_header() |> String.split(",")
  end
end
