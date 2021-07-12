defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Authentication.FlagpoleMock
  alias Belfrage.Dials.ServerMock
  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator
  alias Belfrage.Struct

  @webcore_topic_id %Struct{
    private: %Struct.Private{
      origin: Application.get_env(:belfrage, :mozart_endpoint),
      platform: MozartNews
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
      platform: MozartNews
    },
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core",
      path_params: %{"id" => "abc123xyz789"}
    }
  }

  def enable_personalisation_dial() do
    stub(ServerMock, :state, fn dial ->
      if dial == :personalisation do
        Belfrage.Dials.Personalisation.transform("on")
      else
        Belfrage.Dials.WebcoreKillSwitch.transform("inactive")
      end
    end)
  end

  describe "when personalisation on" do
    setup do
      enable_personalisation_dial()
      # enables flagpole
      expect(FlagpoleMock, :state, fn -> true end)
      :ok
    end

    test "if the Topic ID is in the Webcore allow list, the origin and platform will be altered to the Lambda" do
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
                   path_params: %{"id" => "ck7l4e11g49t"}
                 }
               }
             } = NewsTopicsPlatformDiscriminator.call([], @webcore_topic_id)
    end
  end

  test "if the Topic ID is not in the Webcore allow list, the origin and platform will remain the same" do
    mozart_endpoint = Application.get_env(:belfrage, :mozart_endpoint)

    assert {
             :ok,
             %Struct{
               debug: %Struct.Debug{
                 pipeline_trail: ["CircuitBreaker", "PlatformKillSwitch"]
               },
               private: %Struct.Private{
                 origin: ^mozart_endpoint,
                 platform: MozartNews
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

  describe "path contains a slug" do
    setup do
      %{
        mozart_topic_id:
          Struct.add(@mozart_topic_id, :request, %{path_params: %{"id" => "abc123xyz789", "slug" => "bourbon"}}),
        webcore_topic_id:
          Struct.add(@webcore_topic_id, :request, %{path_params: %{"id" => "ck7l4e11g49t", "slug" => "custard-cream"}})
      }
    end

    test "Topic ID in webcore allowlist, a redirect will be issued without the slug", %{
      webcore_topic_id: webcore_topic_id
    } do
      assert {:redirect,
              %Struct{
                response: %Struct.Response{
                  http_status: 302,
                  headers: %{
                    "location" => "/news/topics/ck7l4e11g49t",
                    "x-bbc-no-scheme-rewrite" => "1",
                    "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                  },
                  body: "Redirecting"
                }
              }} = NewsTopicsPlatformDiscriminator.call([], webcore_topic_id)
    end

    test "Topic ID not in webcore allowlist", %{mozart_topic_id: mozart_topic_id} do
      mozart_endpoint = Application.get_env(:belfrage, :mozart_endpoint)

      assert {
               :ok,
               %Struct{
                 debug: %Struct.Debug{
                   pipeline_trail: ["CircuitBreaker", "PlatformKillSwitch"]
                 },
                 private: %Struct.Private{
                   origin: ^mozart_endpoint,
                   platform: MozartNews
                 },
                 request: %Struct.Request{
                   scheme: :http,
                   host: "www.bbc.co.uk",
                   path: "/_web_core",
                   path_params: %{"id" => "abc123xyz789"}
                 }
               }
             } = NewsTopicsPlatformDiscriminator.call([], mozart_topic_id)
    end
  end
end
