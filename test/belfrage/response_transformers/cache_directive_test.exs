defmodule Belfrage.ResponseTransformers.CacheDirectiveTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.ResponseTransformers.CacheDirective
  alias Belfrage.Struct
  alias Belfrage.Test.StubHelper

  defp set_non_webcore_ttl_multiplier(value) do
    StubHelper.stub_dial(:non_webcore_ttl_multiplier, value)
  end

  defp set_webcore_ttl_multiplier(value) do
    StubHelper.stub_dial(:webcore_ttl_multiplier, value)
  end

  describe "call/1 with varying Webcore multipliers" do
    for webcore_value <- ["very-short", "short", "default", "long", "very-long"] do
      @webcore_value webcore_value
      @webcore_multiplier Belfrage.Dials.WebcoreTtlMultiplier.transform(@webcore_value)

      test "Given a max-age and a #{@webcore_value} webcore_ttl_multiplier, #{@webcore_multiplier} times the original max-age is returned" do
        set_webcore_ttl_multiplier(@webcore_value)

        %{response: response} =
          CacheDirective.call(%Struct{
            response: %Struct.Response{
              headers: %{
                "cache-control" => "private, max-age=30"
              }
            },
            private: %Struct.Private{
              platform: Webcore
            }
          })

        assert response.cache_directive.cacheability == "private"
        assert response.cache_directive.max_age == round(30 * @webcore_multiplier)
      end

      test "Given a max-age of 15 and a #{@webcore_value} webcore_ttl_multiplier, the correct value is returned" do
        set_webcore_ttl_multiplier(@webcore_value)

        %{response: response} =
          CacheDirective.call(%Struct{
            response: %Struct.Response{
              headers: %{
                "cache-control" => "private, max-age=15"
              }
            },
            private: %Struct.Private{
              platform: Webcore
            }
          })

        assert response.cache_directive.cacheability == "private"

        case @webcore_value do
          "very-short" ->
            assert response.cache_directive.max_age == 5

          "short" ->
            assert response.cache_directive.max_age == 10

          "default" ->
            assert response.cache_directive.max_age == 15

          "long" ->
            assert response.cache_directive.max_age == 30

          "very-long" ->
            assert response.cache_directive.max_age == 60
        end
      end
    end
  end

  describe "call/1 with varying non-Webcore multipliers" do
    for non_webcore_value <- ["very-short", "short", "default", "long", "very-long"] do
      @non_webcore_value non_webcore_value
      @non_webcore_multiplier Belfrage.Dials.NonWebcoreTtlMultiplier.transform(@non_webcore_value)

      test "Given a max-age and a #{@non_webcore_value} non_webcore_ttl_multiplier, #{@non_webcore_multiplier} times the original max-age is returned" do
        set_non_webcore_ttl_multiplier(@non_webcore_value)

        %{response: response} =
          CacheDirective.call(%Struct{
            response: %Struct.Response{
              headers: %{
                "cache-control" => "public, max-age=30"
              }
            },
            private: %Struct.Private{
              platform: NonWebcore
            }
          })

        assert response.cache_directive.cacheability == "public"
        assert response.cache_directive.max_age == round(30 * @non_webcore_multiplier)
      end
    end
  end

  describe "call/1 with edge cases" do
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
  end

  describe "call/1 with a personalised request" do
    setup do
      set_non_webcore_ttl_multiplier("default")
      :ok
    end

    test "Given a cache-control set to public, the cacheabilty is set to 'private' and the max_age is set to 0" do
      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{
            personalised_request: true
          }
        })

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 0
    end

    test "Given a cache-control set to private, the cacheabilty remains as 'private' the and max_age is unchanged" do
      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private, max-age=30"
            }
          },
          private: %Struct.Private{
            personalised_request: true
          }
        })

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 30
    end

    test "Given a cache-control set to public and a Webcore platform, the cacheabilty is set to 'private' and the max_age is set to 0" do
      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "public, max-age=30"
            }
          },
          private: %Struct.Private{
            personalised_request: true,
            platform: Webcore
          }
        })

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 0
    end

    test "Given a cache-control set to private and a Webcore platform, the cacheabilty remains as 'private' the and max_age is unchanged" do
      %{response: response} =
        CacheDirective.call(%Struct{
          response: %Struct.Response{
            headers: %{
              "cache-control" => "private, max-age=30"
            }
          },
          private: %Struct.Private{
            personalised_request: true,
            platform: Webcore
          }
        })

      assert response.cache_directive.cacheability == "private"
      assert response.cache_directive.max_age == 30
    end
  end
end
