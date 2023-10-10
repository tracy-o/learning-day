defmodule Belfrage.RequestTransformers.DotComRedirectTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.DotComRedirect
  alias Belfrage.{Envelope, Envelope.Request}

  test "when the request is an international request pass through the envelope unchanged" do
    {:ok, envelope} =
      DotComRedirect.call(%Envelope{
        request: %Request{
          path: "/newsletters",
          is_uk: false
        }
      })

    assert envelope.request.path == "/newsletters"
  end

  test "when the request is a domestic request redirect to the homepage" do
    {:stop, envelope} =
      DotComRedirect.call(%Envelope{
        request: %Request{
          path: "/newsletters",
          is_uk: true
        }
      })

    assert envelope.response.http_status == 302
    assert envelope.response.headers["x-bbc-no-scheme-rewrite"] == "1"
    assert envelope.response.headers["cache-control"] == "public, max-age=60"
    assert envelope.response.headers["location"] == "/"
  end

  test "when the request is from an unknown origin request redirect to the homepage" do
    {:stop, envelope} =
      DotComRedirect.call(%Envelope{
        request: %Request{
          path: "/newsletters",
          is_uk: "not an expected value"
        }
      })

    assert envelope.response.http_status == 302
    assert envelope.response.headers["x-bbc-no-scheme-rewrite"] == "1"
    assert envelope.response.headers["cache-control"] == "public, max-age=60"
    assert envelope.response.headers["location"] == "/"
  end
end
