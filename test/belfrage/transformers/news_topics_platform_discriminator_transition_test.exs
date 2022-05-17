defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTransitionTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTransition
  alias Belfrage.Struct

  setup do
    stub_dials(webcore_kill_switch: "inactive", circuit_breaker: "false")
    %{mozart_news_endpoint: Application.get_env(:belfrage, :mozart_news_endpoint)}
  end

  describe "when the path does not contain a slug" do
    test "if the id is a Topic ID and is in the Mozart allowlist the platform and origin is Mozart and the route and request will be set to not personalised",
         %{
           mozart_news_endpoint: mozart_news_endpoint
         } do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: MozartNews,
                   origin: ^mozart_news_endpoint,
                   personalised_route: false,
                   personalised_request: false
                 }
               }
             } =
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "c2x6gdkj24kt"}},
                 private: %Struct.Private{personalised_route: true, personalised_request: true}
               })
    end

    test "if the id is a Topic ID and is not in the Mozart allowlist the platform and origin are unchanged and the rest of the pipeline is preserved" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: SomePlatform,
                   origin: "https://some.example.origin:test"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminatorTransition.call(
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
                     path_params: %{"id" => "some-id"}
                   }
                 }
               )
    end

    test "if the id is a Things GUID the platform and origin is Mozart and the route and request will be set to not personalised",
         %{
           mozart_news_endpoint: mozart_news_endpoint
         } do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: MozartNews,
                   origin: ^mozart_news_endpoint,
                   personalised_route: false,
                   personalised_request: false
                 }
               }
             } =
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "62d838bb-2471-432c-b4db-f134f98157c2"}},
                 private: %Struct.Private{personalised_route: true, personalised_request: true}
               })
    end
  end

  describe "when the path contains a slug" do
    test "if the id is a Topic ID and is in the Mozart allowlist the platform and origin is Mozart and the route and request will be set to not personalised",
         %{
           mozart_news_endpoint: mozart_news_endpoint
         } do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: MozartNews,
                   origin: ^mozart_news_endpoint,
                   personalised_route: false,
                   personalised_request: false
                 }
               }
             } =
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "c2x6gdkj24kt", "slug" => "some-slug"}},
                 private: %Struct.Private{personalised_route: true, personalised_request: true}
               })
    end

    test "if the id is a Topic ID and is not in the Mozart allowlist, a redirect will be issued without the slug" do
      assert {:redirect,
              %Struct{
                response: %Struct.Response{
                  http_status: 302,
                  headers: %{
                    "location" => "/news/topics/cl16knzkz9yt",
                    "x-bbc-no-scheme-rewrite" => "1",
                    "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                  },
                  body: "Redirecting"
                }
              }} =
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{
                   path: "/_some_path",
                   path_params: %{"id" => "cl16knzkz9yt", "slug" => "some-slug"}
                 }
               })
    end
  end

  test "if the id is a Things GUID the platform and origin is Mozart and the route and request will be set to not personalised",
       %{
         mozart_news_endpoint: mozart_news_endpoint
       } do
    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 platform: MozartNews,
                 origin: ^mozart_news_endpoint,
                 personalised_route: false,
                 personalised_request: false
               }
             }
           } =
             NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
               request: %Struct.Request{
                 path_params: %{"id" => "62d838bb-2471-432c-b4db-f134f98157c2", "slug" => "cybersecurity"}
               },
               private: %Struct.Private{personalised_route: true, personalised_request: true}
             })
  end
end
