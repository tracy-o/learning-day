defmodule Belfrage.RequestTransformers.BitesizeGuidesPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.RequestTransformers.BitesizeGuidesPlatformDiscriminator
  alias Belfrage.Envelope

  @webcore_test_data %Envelope{
    private: %Envelope.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: "MorphRouter",
      production_environment: "test"
    },
    request: %Envelope.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "zw3bfcw"}
    }
  }

  @morph_test_data %Envelope{
    private: %Envelope.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: "MorphRouter",
      production_environment: "test"
    },
    request: %Envelope.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "abc123xyz789"}
    }
  }

  @morph_live_data %Envelope{
    private: %Envelope.Private{
      origin: "https://morph-router.api.bbci.co.uk",
      platform: "MorphRouter"
    },
    request: %Envelope.Request{
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

  test "if the Guide ID is in the Test Webcore allow list, the origin and platform will be altered to the Lambda" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function)

    assert {
             :ok,
             %Envelope{
               private: %Envelope.Private{
                 origin: ^lambda_function,
                 platform: "Webcore"
               }
             }
           } = BitesizeGuidesPlatformDiscriminator.call(@webcore_test_data)
  end

  test "if on Test environment and the Guide ID is not in the whitelist, the origin and platform will remain the same" do
    morph_endpoint = "https://morph-router.test.api.bbci.co.uk"

    assert {
             :ok,
             %Envelope{
               private: %Envelope.Private{
                 origin: ^morph_endpoint,
                 platform: "MorphRouter"
               }
             }
           } = BitesizeGuidesPlatformDiscriminator.call(@morph_test_data)
  end

  test "if on Live environment and the Guide ID is not in the whitelist, the origin and platform will remain the same" do
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, "live")
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)
    morph_endpoint = "https://morph-router.api.bbci.co.uk"

    assert {
             :ok,
             %Envelope{
               private: %Envelope.Private{
                 origin: ^morph_endpoint,
                 platform: "MorphRouter"
               }
             }
           } = BitesizeGuidesPlatformDiscriminator.call(@morph_live_data)
  end
end
