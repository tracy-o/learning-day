defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTest do
  use ExUnit.Case

  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_topic_id %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Mozart
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "ck7l4e11g49t"}
    }
  }

  @mozart_topic_id %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Mozart
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "abc123xyz789"}
    }
  }

  test "if the Topic ID is in the Webcore allow list, the origin and platform will be altered to the Lambda" do
    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["Language", "CircuitBreaker", "LambdaOriginAlias"]
               },
               private: %Struct.Private{
                 origin: "pwa-lambda-function:live",
                 platform: Webcore
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"id" => "ck7l4e11g49t"}
               }
             }
           } = NewsTopicsPlatformDiscriminator.call([], @webcore_topic_id)
  end

  test "if the Topic ID is not in the Webcore allow list, the origin and platform will remain the same" do
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
                 path_params: %{"id" => "abc123xyz789"}
               }
             }
           } = NewsTopicsPlatformDiscriminator.call([], @mozart_topic_id)
  end
end
