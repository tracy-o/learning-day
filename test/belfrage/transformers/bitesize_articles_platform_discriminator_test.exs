defmodule Belfrage.Transformers.BitesizeArticlesPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Transformers.BitesizeArticlesPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_test_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: MorphRouter,
      production_environment: "test"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "zm8fhbk"}
    }
  }

  @morph_test_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: MorphRouter,
      production_environment: "test",
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "abc123xyz789"}
    }
  }

  @morph_live_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.api.bbci.co.uk",
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

  test "if the Article ID is in the Test Webcore allow list, the origin and platform will be altered to the Lambda" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function)

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: []
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
           } = BitesizeArticlesPlatformDiscriminator.call([], @webcore_test_data)
  end

  test "if the Article ID is not in the Test Webcore allow list, the origin and platform will remain the same" do
    morph_endpoint = "https://morph-router.test.api.bbci.co.uk"

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: []
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
           } = BitesizeArticlesPlatformDiscriminator.call([], @morph_test_data)
  end

  test "if the Article ID is not in the Live Webcore allow list, the origin and platform will remain the same" do
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, "live")
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)
    morph_endpoint = "https://morph-router.api.bbci.co.uk"

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: []
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
           } = BitesizeArticlesPlatformDiscriminator.call([], @morph_live_data)
  end
end
