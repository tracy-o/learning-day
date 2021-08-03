defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.ResponseTransformers.CacheDirective
  alias Belfrage.Struct
  alias Belfrage.Test.StubHelper

  defp set_ttl_multiplier(value) do
    StubHelper.stub_dial(:ttl_multiplier, value)
  end

  defp set_webcore_ttl_multiplier(value) do
    StubHelper.stub_dial(:webcore_ttl_multiplier, value)
  end

  describe "&call/1 with default multipliers" do
    setup do
      set_ttl_multiplier("default")
      :ok
    end

    test "Given no cache_control response header, nothing is changed" do
      assert CacheDirective.call(%Struct{}) == %Struct{}
    end

    test "Given a cache control with no max-age, the max-age remains unprovided" do
      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private"
            }
          }
        })

      assert response.cache_directive.max_age == nil
      assert response.cache_directive.cacheability == "private"
    end

    test "Given a max-age, with default multipliers, the max-age remains unchanged" do
      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "max-age=30"
            }
          }
        })

      assert response.cache_directive.max_age == 30
    end
  end

  describe "&call/1 Given a non-personalised request struct and default ttl multiplier" do
    setup do
      set_ttl_multiplier("default")
      :ok
    end

    test "with cache-control set to public, in the response cache directive the cacheabilty is set to \"public\" and the max_age is unchanged" do
      %{response: response} =
        %Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=1000"
            }
          }
        }
        |> CacheDirective.call()

      assert response.cache_directive.cacheability == "public"
      assert response.cache_directive.max_age == 1000
    end

    test "with cache-control set to private, in the response cache directive the cacheabilty is set to \"private\" and the max_age is unchanged" do
      %{response: response} =
        %Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private, max-age=1000"
            }
          }
        }
        |> CacheDirective.call()

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 1000
    end
  end

  describe "&call/1 Given a personalised request struct and default ttl multiplier" do
    setup do
      set_ttl_multiplier("default")
      :ok
    end

    test "with cache-control set to public, in the response cache directive the cacheabilty is set to \"private\" and the max_age is set to 0" do
      %{response: response} =
        %Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=1000"
            }
          },
          private: %Struct.Private{
            personalised_request: true
          }
        }
        |> CacheDirective.call()

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 0
    end

    test "with cache-control set to private, in the response cache directive the cacheabilty is set to \"private\" the and max_age is unchanged" do
      %{response: response} =
        %Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private, max-age=1000"
            }
          },
          private: %Struct.Private{
            personalised_request: true
          }
        }
        |> CacheDirective.call()

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 1000
    end
  end

  describe "&call/1 with altered ttl_multiplier" do
    test "Given a max-age and a private ttl_multiplier, the max-age is set to 0 and the cacheability is set to private" do
      set_ttl_multiplier("private")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          }
        })

      assert response.cache_directive.max_age == 0
      assert response.cache_directive.cacheability == "private"
    end

    test "Given a max-age and a long ttl_multiplier, 3 times the original max-age is returned" do
      set_ttl_multiplier("long")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          }
        })

      assert response.cache_directive.max_age == 90
    end

    test "Given a max-age and a super_long ttl_multiplier, 10 times the original max-age is returned" do
      set_ttl_multiplier("super_long")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          }
        })

      assert response.cache_directive.max_age == 300
    end

    test "Given no max-age, and a long ttl_multiplier, the max-age remains unprovided" do
      set_ttl_multiplier("long")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private"
            }
          }
        })

      assert response.cache_directive.max_age == nil
    end
  end

  describe "&call/1 with altered webcore_ttl_multiplier" do
    test "Given a max-age, a non Webcore platform the ttl_multiplier is used and 3 times the original max-age is returned" do
      set_ttl_multiplier("long")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{platform: NotWebcore}
        })

      assert response.cache_directive.max_age == 90
    end

    test "Given a max-age, a Webcore platform and a one webcore_ttl_multiplier the original max-age is returned" do
      set_webcore_ttl_multiplier("one")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{platform: Webcore}
        })

      assert response.cache_directive.max_age == 30
    end

    test "Given a max-age, a Webcore platform and a half webcore_ttl_multiplier, 0.5 times the original max-age is returned" do
      set_webcore_ttl_multiplier("half")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{platform: Webcore}
        })

      assert response.cache_directive.max_age == 15
    end

    test "Given a max-age, a Webcore platform and a three-quarters webcore_ttl_multiplier, 0.75 times the original max-age is returned" do
      set_webcore_ttl_multiplier("three-quarters")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{platform: Webcore}
        })

      assert response.cache_directive.max_age == 23
    end

    test "Given a max-age, a Webcore platform and a two webcore_ttl_multiplier, 2 times the original max-age is returned" do
      set_webcore_ttl_multiplier("two")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{platform: Webcore}
        })

      assert response.cache_directive.max_age == 60
    end

    test "Given a max-age, a Webcore platform and a four webcore_ttl_multiplier, 4 times the original max-age is returned" do
      set_webcore_ttl_multiplier("four")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{platform: Webcore}
        })

      assert response.cache_directive.max_age == 120
    end

    test "Given no max-age, a Webcore platform and a four webcore_ttl_multiplier the max-age remains unprovided" do
      set_webcore_ttl_multiplier("four")

      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private"
            }
          },
          private: %Struct.Private{platform: Webcore}
        })

      assert response.cache_directive.max_age == nil
    end
  end
end
