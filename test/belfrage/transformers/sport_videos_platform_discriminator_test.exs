defmodule Belfrage.Transformers.SportVideosPlatformDiscriminatorTest do
  use ExUnit.Case

  alias Belfrage.Transformers.SportVideosPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_section_test %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Mozart,
      production_environment: "test"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"section" => "sports-personality"}
    }
  }

  @mozart_section_test %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Mozart,
      production_environment: "test"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"section" => "fencing"}
    }
  }

  @mozart_section_live %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Mozart
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"section" => "fencing"}
    }
  }

  @webcore_section_preview %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Mozart,
      preview_mode: "on"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"section" => "football"}
    }
  }

  test "if the section is in the WebCore test allow list and the environment is test, the origin and platform will be altered to the Lambda" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function) <> ":test"

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["Language", "CircuitBreaker", "LambdaOriginAlias"]
               },
               private: %Struct.Private{
                 origin: ^lambda_function,
                 platform: Webcore
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"section" => "sports-personality"}
               }
             }
           } = SportVideosPlatformDiscriminator.call([], @webcore_section_test)
  end

  test "if the section is not in the Webcore test allow list and the environment is test, the origin and platform will remain the same" do
    mozart_endpoint = Application.get_env(:belfrage, :mozart_endpoint)

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["CircuitBreaker"]
               },
               private: %Struct.Private{
                 origin: ^mozart_endpoint,
                 platform: Mozart
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"section" => "fencing"}
               }
             }
           } = SportVideosPlatformDiscriminator.call([], @mozart_section_test)
  end

  test "if the section is not in the Webcore live allow list and the environment is live, the origin and platform will remain the same" do
    mozart_endpoint = Application.get_env(:belfrage, :mozart_endpoint)

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["CircuitBreaker"]
               },
               private: %Struct.Private{
                 origin: ^mozart_endpoint,
                 platform: Mozart
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"section" => "fencing"}
               }
             }
           } = SportVideosPlatformDiscriminator.call([], @mozart_section_live)
  end

  test "if preview mode is on, the origin and platform will be altered to the Lambda" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function) <> ":www"

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["Language", "CircuitBreaker", "LambdaOriginAlias"]
               },
               private: %Struct.Private{
                 origin: ^lambda_function,
                 platform: Webcore
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"section" => "football"}
               }
             }
           } = SportVideosPlatformDiscriminator.call([], @webcore_section_preview)
  end
end
