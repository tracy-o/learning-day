defmodule Belfrage.Transformers.UploaderPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Transformers.UploaderPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_live_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.api.bbci.co.uk",
      platform: MorphRouter,
      production_environment: "live"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "u4033755"}
    }
  }

  @morph_live_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.api.bbci.co.uk",
      platform: MorphRouter,
      production_environment: "live"
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

  test "if the Campaign ID is in the Live Webcore allow list, the origin and platform will be altered to the Lambda on live" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function)
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, "live")
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: ^lambda_function,
                 platform: Webcore
               }
             }
           } = UploaderPlatformDiscriminator.call([], @webcore_live_data)
  end

  test "if the Campaign ID is not in the Live Webcore allow list, the origin and platform will remain the same on live" do
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, "live")
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)
    morph_endpoint = "https://morph-router.api.bbci.co.uk"

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: ^morph_endpoint,
                 platform: MorphRouter
               }
             }
           } = UploaderPlatformDiscriminator.call([], @morph_live_data)
  end
end
