defmodule Belfrage.RequestTransformers.DomesticToBBCXRedirectTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.DomesticToBBCXRedirect
  alias Belfrage.{Envelope, Envelope.Request}

  setup do
    stub_dials(bbcx_enabled: "true")
  end

  test "when the envelope request path is not in the BBCX redirect map then we pass through the envelope unchanged" do
    {:ok, envelope} =
      DomesticToBBCXRedirect.call(%Envelope{
        request: %Request{
          path: "/news/topics/not-in-redirect-map",
          host: "www.bbc.com"
        }
      })

    assert envelope.request.path == "/news/topics/not-in-redirect-map"
    assert envelope.request.host == "www.bbc.com"
  end

  test "when the envelope request path is in the BBCX redirect map then we redirect to the correct path from the redirect map" do
    {:stop, envelope} =
      DomesticToBBCXRedirect.call(%Envelope{
        request: %Request{
          path: "/news/topics/cw9l5jelpl1t"
        }
      })

    assert envelope.response.http_status == 302
    assert envelope.response.headers["x-bbc-no-scheme-rewrite"] == "1"
    assert envelope.response.headers["cache-control"] == "public, max-age=60"
    assert envelope.response.headers["location"] == "/business/technology-of-business"
  end
end
