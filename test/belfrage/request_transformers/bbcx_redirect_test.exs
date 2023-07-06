defmodule Belfrage.RequestTransformers.BBCXRedirectTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.BBCXRedirect
  alias Belfrage.{Envelope, Envelope.Request}

  test "when the envelope data does not fulfill bbcx selection requirements then we redirect to the correct path from the redirect map" do
    {:stop, envelope} =
      BBCXRedirect.call(%Envelope{
        request: %Request{
          path: "/news/war-in-ukraine",
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert envelope.response.http_status == 302
    assert envelope.response.headers["x-bbc-no-scheme-rewrite"] == "1"
    assert envelope.response.headers["cache-control"] == "public, max-age=60"
    assert envelope.response.headers["location"] == "/news/world-60525350"
  end

  test "when the envelope data fulfills the bbcx selection requirements then we continue without redirection" do
    {:ok, envelope} =
      BBCXRedirect.call(%Envelope{
        request: %Request{
          path: "/news/war-in-ukraine",
          host: "www.bbc.com",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert envelope.request.path == "/news/war-in-ukraine"
    assert envelope.request.host == "www.bbc.com"
    assert envelope.response.http_status == nil
  end

  test "when the envelope data does not fulfill bbcx selection requirements but there is no entry in the redirect map for the path" do
    {:stop, envelope} =
      BBCXRedirect.call(%Envelope{
        request: %Request{
          path: "/innovation/1234",
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert envelope.response.http_status == 302
    assert envelope.response.headers["x-bbc-no-scheme-rewrite"] == "1"
    assert envelope.response.headers["cache-control"] == "public, max-age=60"
    assert envelope.response.headers["location"] == "/"
  end

  test "when the envelope data fulfills the bbcx selection requirements" do
    {:ok, envelope} =
      BBCXRedirect.call(%Envelope{
        request: %Request{
          path: "/innovation/1234",
          host: "www.bbc.com",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert envelope.request.path == "/innovation/1234"
    assert envelope.request.host == "www.bbc.com"
    assert envelope.response.http_status == nil
  end
end
