defmodule Belfrage.Transformers.AppSubdomainMapperTest do
  use ExUnit.Case, async: true

  alias Belfrage.Transformers.AppSubdomainMapper
  alias Belfrage.Struct
  alias Belfrage.Struct.{Private, Request, Response}

  describe "when subdomain is 'news-app-classic'" do
    test "point to trevor platform, set circuit_breaker_error_threshold to 15,000" do
      trevor_endpoint = Application.get_env(:belfrage, :trevor_endpoint)

      struct = %Struct{
        request: %Request{
          subdomain: "news-app-classic"
        },
        private: %Private{
          circuit_breaker_error_threshold: 15_000
        }
      }

      assert {:ok,
              %Struct{
                private: %Private{
                  origin: ^trevor_endpoint,
                  circuit_breaker_error_threshold: 15_000,
                  platform: AppsTrevor
                }
              }} = AppSubdomainMapper.call([], struct)
    end
  end

  describe "when subdomain is 'news-app-global-classic'" do
    test "point to walter, set circuit_breaker_error_threshold to 8,000" do
      walter_endpoint = Application.get_env(:belfrage, :walter_endpoint)

      struct = %Struct{
        request: %Request{
          subdomain: "news-app-global-classic"
        },
        private: %Private{
          circuit_breaker_error_threshold: 8_000
        }
      }

      assert {:ok,
              %Struct{
                private: %Private{
                  origin: ^walter_endpoint,
                  circuit_breaker_error_threshold: 8_000,
                  platform: AppsWalter
                }
              }} = AppSubdomainMapper.call([], struct)
    end
  end

  describe "when subdomain is 'news-app-ws-classic'" do
    test "point to philippa, set circuit_breaker_error_threshold to 1,500" do
      philippa_endpoint = Application.get_env(:belfrage, :philippa_endpoint)

      struct = %Struct{
        request: %Request{
          subdomain: "news-app-ws-classic"
        },
        private: %Private{
          circuit_breaker_error_threshold: 1_500
        }
      }

      assert {:ok,
              %Struct{
                private: %Private{
                  origin: ^philippa_endpoint,
                  circuit_breaker_error_threshold: 1_500,
                  platform: AppsPhilippa
                }
              }} = AppSubdomainMapper.call([], struct)
    end
  end

  describe "when subdomain is none of the above" do
    test "the pipeline will stop and return a 400" do
      struct = %Struct{
        request: %Request{
          subdomain: "another-subdomain"
        }
      }

      assert {:stop_pipeline,
              %Struct{
                response: %Response{
                  http_status: 400
                }
              }} = AppSubdomainMapper.call([], struct)
    end
  end
end
