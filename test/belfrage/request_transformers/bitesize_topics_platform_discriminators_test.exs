defmodule Belfrage.RequestTransformers.BitesizeTopicsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.RequestTransformers.BitesizeTopicsPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_test_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: "MorphRouter",
      production_environment: "test"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "z82hsbk"}
    }
  }

  @webcore_test_data_with_year %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: "MorphRouter",
      production_environment: "test"
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "z82hsbk", "year_id" => "zmyxxyc"}
    }
  }

  @morph_test_data %Struct{
    private: %Struct.Private{
      origin: "https://morph-router.test.api.bbci.co.uk",
      platform: "MorphRouter",
      production_environment: "test"
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
      platform: "MorphRouter"
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

  test "if the topic ID is in the Test Webcore allow list, the origin and platform will be altered" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: ^lambda_function,
                 platform: "Webcore"
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path_params: %{"id" => "z82hsbk"}
               }
             }
           } = BitesizeTopicsPlatformDiscriminator.call(@webcore_test_data)
  end

  test "if the topic ID is not in the Test Webcore allow list, the origin and platform will remain the same" do
    morph_endpoint = "https://morph-router.test.api.bbci.co.uk"

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: ^morph_endpoint,
                 platform: "MorphRouter"
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"id" => "abc123xyz789"}
               }
             }
           } = BitesizeTopicsPlatformDiscriminator.call(@morph_test_data)
  end

  test "if the topic ID is not in the Live Webcore allow list, the origin and platform will remain the same" do
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, "live")
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)
    morph_endpoint = "https://morph-router.api.bbci.co.uk"

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: ^morph_endpoint,
                 platform: "MorphRouter"
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"id" => "abc123xyz789"}
               }
             }
           } = BitesizeTopicsPlatformDiscriminator.call(@morph_live_data)
  end

  test "if the topic ID and year Id is in the Test Webcore allow list, the origin and platform will be altered" do
    lambda_function = Application.get_env(:belfrage, :pwa_lambda_function)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: ^lambda_function,
                 platform: "Webcore"
               },
               request: %Struct.Request{
                 scheme: :http,
                 host: "www.bbc.co.uk",
                 path: "/_web_core",
                 path_params: %{"id" => "z82hsbk", "year_id" => "zmyxxyc"}
               }
             }
           } = BitesizeTopicsPlatformDiscriminator.call(@webcore_test_data_with_year)
  end
end
