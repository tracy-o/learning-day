defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator
  alias Belfrage.Struct

  setup do
    stub_dials(webcore_kill_switch: "inactive", circuit_breaker: "false")

    %{
      mozart_news_endpoint: Application.get_env(:belfrage, :mozart_news_endpoint),
      pwa_lambda_function: Application.get_env(:belfrage, :pwa_lambda_function)
    }
  end

  describe "path does not contain a slug" do
    test "if the Topic ID is not in the Webcore allow list the platform and origin will be altered to Mozart News", %{
      mozart_news_endpoint: mozart_news_endpoint
    } do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: MozartNews,
                   origin: ^mozart_news_endpoint
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "some-id"}}
               })
    end

    test "Topic ID in webcore allowlist, the platform and origin will be unchanged" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: SomePlatform,
                   origin: "https://some.example.origin:test"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(
                 [
                   "Personalisation",
                   "LambdaOriginAlias",
                   "Language",
                   "PlatformKillSwitch",
                   "Chameleon",
                   "CircuitBreaker",
                   "DevelopmentRequests"
                 ],
                 %Struct{
                   private: %Struct.Private{
                     origin: "https://some.example.origin",
                     platform: SomePlatform,
                     production_environment: "test"
                   },
                   request: %Struct.Request{
                     path_params: %{"id" => "c4mr5v9znzqt"}
                   }
                 }
               )
    end
  end

  describe "path contains a slug" do
    test "Topic ID in webcore allowlist, a redirect will be issued without the slug" do
      assert {:redirect,
              %Struct{
                response: %Struct.Response{
                  http_status: 302,
                  headers: %{
                    "location" => "/news/topics/c4mr5v9znzqt",
                    "x-bbc-no-scheme-rewrite" => "1",
                    "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                  },
                  body: "Redirecting"
                }
              }} =
               NewsTopicsPlatformDiscriminator.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "c4mr5v9znzqt", "slug" => "some-slug"}}
               })
    end

    test "if the Topic ID is not in the Webcore allow list the platform and origin will be altered to Mozart News", %{
      mozart_news_endpoint: mozart_news_endpoint
    } do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: MozartNews,
                   origin: ^mozart_news_endpoint
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "some-id", "slug" => "some-slug"}}
               })
    end
  end
end
