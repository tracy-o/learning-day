defmodule Belfrage.RequestTransformers.NewsAvRedirectTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.NewsAvRedirect
  alias Belfrage.{Envelope, Envelope.Request}

  test "redirect if preflight AresData asset type is MAP" do
    assert {:stop, envelope} = NewsAvRedirect.call(req_envelope(%{"AresData" => "MAP"}))
    assert envelope.response.http_status == 301
    assert envelope.response.headers["x-bbc-no-scheme-rewrite"] == "1"
    assert envelope.response.headers["location"] == "/news/av/world-us-canada-66517506"

    assert envelope.response.headers["cache-control"] ==
             "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
  end

  test "do not redirect if preflight AresData asset type is not MAP" do
    envelope = req_envelope(%{"AresData" => "CSP"})
    assert {:ok, ^envelope} = NewsAvRedirect.call(envelope)
  end

  test "do not redirect if preflight metadata is absent" do
    envelope = req_envelope(%{})
    assert {:ok, ^envelope} = NewsAvRedirect.call(envelope)
  end

  test "do not redirect if path is not /news/:id" do
    envelope = req_envelope("/news/av/world-us-canada-66517506", %{"AresData" => "MAP"})
    assert {:ok, ^envelope} = NewsAvRedirect.call(envelope)
  end

  defp req_envelope(preflight_metadata) do
    req_envelope("/news/world-us-canada-66517506", preflight_metadata)
  end

  defp req_envelope(path, preflight_metadata) do
    %Envelope{
      request: %Request{
        path: path,
        host: "www.bbc.co.uk",
        path_params: %{"id" => "world-us-canada-66517506"}
      },
      private: %Envelope.Private{preflight_metadata: preflight_metadata}
    }
  end
end
