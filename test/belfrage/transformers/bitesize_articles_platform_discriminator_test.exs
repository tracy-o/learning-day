defmodule Belfrage.Transformers.BitesizeArticlesPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Transformers.BitesizeArticlesPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_id %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: Webcore
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "zm8fhbk"}
    }
  }

  @morph_data %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :morph_endpoint),
      platform: MorphRouter
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "abc123xyz789"}
    }
  }

  setup do
    stub(Belfrage.Dials.ServerMock, :state, fn :webcore_kill_switch ->
      Belfrage.Dials.WebcoreKillSwitch.transform("inactive")
    end)
    :ok
  end

  test "if the Article ID is in the Webcore allow list, the origin and platform will be altered to the Lambda" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function) <> ":live"
    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: [
                   "Language",
                   "CircuitBreaker",
                   "PlatformKillSwitch",
                   "LambdaOriginAlias",
                   "Personalisation"
                 ]
               },
               private: %Struct.Private{
                 origin: ^lambda_function,
                 platform: Webcore
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"id" => "zm8fhbk"}
               }
             }
           } = BitesizeArticlesPlatformDiscriminator.call([], @webcore_id)
  end

  test "if the Article ID is not in the Webcore allow list, the origin and platform will remain the same" do
    morph_endpoint = Application.get_env(:belfrage, :morph_endpoint)
    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["CircuitBreaker"]
               },
               private: %Struct.Private{
                 origin: ^morph_endpoint,
                 platform: MorphRouter
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"id" => "abc123xyz789"}
               }
             }
           } = BitesizeArticlesPlatformDiscriminator.call([], @morph_data)
  end
end
