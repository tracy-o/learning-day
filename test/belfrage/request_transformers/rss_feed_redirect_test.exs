defmodule Belfrage.RequestTransformers.RssFeedRedirectTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.RssFeedRedirect
  alias Belfrage.Struct

  test "requests to the www subdomain are redirected to the feeds subdomain" do
    struct = %Struct{
      request: %Struct.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/sport/rss.xml",
        subdomain: "www"
      }
    }

    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://feeds.bbci.co.uk/sport/rss.xml",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } = RssFeedRedirect.call([], struct)
  end

  test "redirects strip any query parameters" do
    struct = %Struct{
      request: %Struct.Request{
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
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://feeds.bbci.co.uk/sport/rss.xml",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } = RssFeedRedirect.call([], struct)
  end

  test "requests to the feeds subdomain are left unchanged" do
    struct = %Struct{
      request: %Struct.Request{
        scheme: :https,
        host: "feeds.bbci.co.uk",
        path: "/sport/rss.xml",
        subdomain: "feeds"
      }
    }

    assert {:ok, ^struct} = RssFeedRedirect.call([], struct)
  end
end
