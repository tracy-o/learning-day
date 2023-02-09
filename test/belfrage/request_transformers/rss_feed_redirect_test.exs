defmodule Belfrage.RequestTransformers.RssFeedRedirectTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.RssFeedRedirect
  alias Belfrage.Envelope

  test "requests to the www subdomain are redirected to the feeds subdomain" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/sport/rss.xml",
        subdomain: "www"
      }
    }

    assert {
             :stop,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://feeds.bbci.co.uk/sport/rss.xml",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } = RssFeedRedirect.call(envelope)
  end

  test "redirects strip any query parameters" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/sport/rss.xml",
        subdomain: "www",
        query_params: %{
          "foo" => "bar"
        }
      }
    }

    assert {
             :stop,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://feeds.bbci.co.uk/sport/rss.xml",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } = RssFeedRedirect.call(envelope)
  end

  test "requests to the feeds subdomain are left unchanged" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "feeds.bbci.co.uk",
        path: "/sport/rss.xml",
        subdomain: "feeds"
      }
    }

    assert {:ok, ^envelope} = RssFeedRedirect.call(envelope)
  end
end
