defmodule Belfrage.ResponseTransformers.ClassicAppCacheControlTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.ResponseTransformers.ClassicAppCacheControl

  test "does not modify cache control when not a classic app host" do
    struct_with_non_classic_app_host =
      ClassicAppCacheControl.call(%Struct{
        request: %Struct.Request{subdomain: "www.test.bbc.co.uk"},
        response: %Struct.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 5}
        }
      })

    assert struct_with_non_classic_app_host.response.cache_directive == %Belfrage.CacheControl{
             cacheability: "public",
             max_age: 5
           }
  end

  test "does not modify cache control when classic app host but max age not less than 60" do
    struct_with_classic_app_host_with_max_age_not_under_60 =
      ClassicAppCacheControl.call(%Struct{
        request: %Struct.Request{subdomain: "news-app-classic"},
        response: %Struct.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 60}
        }
      })

    assert struct_with_classic_app_host_with_max_age_not_under_60.response.cache_directive == %Belfrage.CacheControl{
             cacheability: "public",
             max_age: 60
           }
  end

  test "modifies cache control when classic app host and max age less than 60" do
    struct_with_classic_app_host_with_max_age_under_60 =
      ClassicAppCacheControl.call(%Struct{
        request: %Struct.Request{subdomain: "news-app-classic"},
        response: %Struct.Response{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 5}
        }
      })

    assert struct_with_classic_app_host_with_max_age_under_60.response.cache_directive == %Belfrage.CacheControl{
             cacheability: "public",
             max_age: 60
           }
  end
end
