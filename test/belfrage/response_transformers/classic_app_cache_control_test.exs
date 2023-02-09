defmodule Belfrage.ResponseTransformers.ClassicAppCacheControlTest do
  use ExUnit.Case

  alias Belfrage.Envelope
  alias Belfrage.ResponseTransformers.ClassicAppCacheControl

  test "does not modify cache control when not a classic app host" do
    {:ok, envelope_with_non_classic_app_host} =
      ClassicAppCacheControl.call(%Envelope{
        request: %Envelope.Request{subdomain: "www.test.bbc.co.uk"},
        response: %Envelope.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 5}
        }
      })

    assert envelope_with_non_classic_app_host.response.cache_directive == %Belfrage.CacheControl{
             cacheability: "public",
             max_age: 5
           }
  end

  test "does not modify cache control when classic app host but max age not less than 60" do
    {:ok, envelope_with_classic_app_host_with_max_age_not_under_60} =
      ClassicAppCacheControl.call(%Envelope{
        request: %Envelope.Request{subdomain: "news-app-classic"},
        response: %Envelope.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 60}
        }
      })

    assert envelope_with_classic_app_host_with_max_age_not_under_60.response.cache_directive == %Belfrage.CacheControl{
             cacheability: "public",
             max_age: 60
           }
  end

  test "modifies cache control when classic app host and max age less than 60" do
    {:ok, envelope_with_classic_app_host_with_max_age_under_60} =
      ClassicAppCacheControl.call(%Envelope{
        request: %Envelope.Request{subdomain: "news-app-classic"},
        response: %Envelope.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 5}
        }
      })

    assert envelope_with_classic_app_host_with_max_age_under_60.response.cache_directive == %Belfrage.CacheControl{
             cacheability: "public",
             max_age: 60
           }
  end
end
