defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.ResponseTransformers.CacheDirective
  alias Belfrage.Struct

  def set_multipliers(%{webcore_ttl_multiplier: webcore_ttl_multiplier, ttl_multiplier: ttl_multiplier}) do
    stub(Belfrage.Dials.ServerMock, :state, fn
      :webcore_ttl_multiplier ->
        Belfrage.Dials.WebcoreTtlMultiplier.transform(webcore_ttl_multiplier)

      :ttl_multiplier ->
        Belfrage.Dials.TtlMultiplier.transform(ttl_multiplier)
    end)
  end

  describe "&call/1 with default multipliers" do
    setup do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "default"})
      :ok
    end

    test "Given no cache_control response header, nothing is changed" do
      assert CacheDirective.call(%Struct{}) == %Struct{}
    end

    test "Given a cache control with no max-age, the max-age remains unprovided" do
      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               }
             }).response.cache_directive.max_age == nil
    end

    test "Given a max-age, with default multipliers, the max-age remains unchanged" do
      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 1000
    end
  end

  describe "&call/1 with altered ttl_multiplier" do
    setup do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "default"})
      :ok
    end

    test "Given a max-age and a private ttl_multiplier, the max-age is set to 0 and the cacheability is set to private" do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "private"})

      struct = CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             })

             assert struct.response.cache_directive.max_age == 0
             assert struct.response.cache_directive.cacheability == "private"
    end

    test "Given a max-age and a long ttl_multiplier, 3 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "long"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 3000
    end

    test "Given a max-age and a super_long ttl_multiplier, 10 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "super_long"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               }
             }).response.cache_directive.max_age == 10000
    end

    test "Given no max-age, and a long ttl_multiplier, the max-age remains unprovided" do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "long"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               }
             }).response.cache_directive.max_age == nil
    end
  end

  describe "&call/1 with altered webcore_ttl_multiplier" do
    setup do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "default"})
      :ok
    end

    test "Given a max-age, a non Webcore platform and a 4x webcore_ttl_multiplier the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "4x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: NotWebcore}
             }).response.cache_directive.max_age == 1000
    end

    test "Given a max-age, a Webcore platform and a 1x webcore_ttl_multiplier the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == 1000
    end

    test "Given a max-age, a Webcore platform and a 0.5x webcore_ttl_multiplier, 0.5 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "0.5x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == 500
    end

    test "Given a max-age, a Webcore platform and a 0.8x webcore_ttl_multiplier, 0.8 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "0.8x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == 800
    end

    test "Given a max-age, a Webcore platform and a 2x webcore_ttl_multiplier, 2 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "2x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == 2000
    end

    test "Given a max-age, a Webcore platform and a 4x webcore_ttl_multiplier, 4 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "4x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == 4000
    end

    test "Given no max-age, a Webcore platform and a 4x webcore_ttl_multiplier the max-age remains unprovided" do
      set_multipliers(%{webcore_ttl_multiplier: "4x", ttl_multiplier: "default"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "private"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == nil
    end
  end

  describe "&call/1 with multiple altered multipliers" do
    setup do
      set_multipliers(%{webcore_ttl_multiplier: "1x", ttl_multiplier: "default"})
      :ok
    end

    test "Given a max-age, a Webcore platform, a 4x webcore_ttl_multiplier and a super_long ttl_multiplier, 40 times the original max-age is returned" do
      set_multipliers(%{webcore_ttl_multiplier: "4x", ttl_multiplier: "super_long"})

      assert CacheDirective.call(%Struct{
               response: %Struct.Response{
                 headers: %{
                   "cache-control" => "public, max-age=1000"
                 }
               },
               private: %Struct.Private{platform: Webcore}
             }).response.cache_directive.max_age == 40000
    end

    test "Given a max-age, a Webcore platform, a 2x webcore_ttl_multiplier and a private ttl_multiplier, the max-age is set to 0 and the cacheability is set to private" do
      set_multipliers(%{webcore_ttl_multiplier: "2x", ttl_multiplier: "private"})

      struct = CacheDirective.call(%Struct{
        response: %Struct.Response{
          headers: %{
            "cache-control" => "public, max-age=1000"
          }
        },
        private: %Struct.Private{platform: Webcore}
      })

      assert struct.response.cache_directive.max_age == 0
      assert struct.response.cache_directive.cacheability == "private"
    end

    test "Given a max-age, a Webcore platform, a 0.8x webcore_ttl_multiplier and a long ttl_multiplier, 2.4x times the original max-age is returned rounded" do
      set_multipliers(%{webcore_ttl_multiplier: "0.8x", ttl_multiplier: "long"})

      assert CacheDirective.call(%Struct{
        response: %Struct.Response{
          headers: %{
            "cache-control" => "public, max-age=3"
          }
        },
        private: %Struct.Private{platform: Webcore}
      }).response.cache_directive.max_age == 7
    end
  end
end
