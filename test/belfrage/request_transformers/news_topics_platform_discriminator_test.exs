defmodule Belfrage.RequestTransformers.NewsTopicsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.NewsTopicsPlatformDiscriminator
  alias Belfrage.Envelope

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
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews",
                   origin: ^mozart_news_endpoint,
                   personalised_route: false,
                   personalised_request: false
                 }
               },
               {:replace, ["CircuitBreaker"]}
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{path_params: %{"id" => "cdr8nnnw9ngt"}},
                 private: %Envelope.Private{personalised_route: true, personalised_request: true}
               })
    end

    test "if the id is a Topic ID and is not in the Mozart allowlist the platform and origin are unchanged and the rest of the pipeline is preserved" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "SomePlatform",
                   origin: "https://some.example.origin"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 private: %Envelope.Private{
                   origin: "https://some.example.origin",
                   platform: "SomePlatform",
                   production_environment: "test"
                 },
                 request: %Envelope.Request{
                   path_params: %{"id" => "some-id"}
                 }
               })
    end

    test "if the id is a Things GUID the platform and origin is Mozart and the route and request will be set to not personalised",
         %{
           mozart_news_endpoint: mozart_news_endpoint
         } do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews",
                   origin: ^mozart_news_endpoint,
                   personalised_route: false,
                   personalised_request: false
                 }
               },
               {:replace, ["CircuitBreaker"]}
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{path_params: %{"id" => "62d838bb-2471-432c-b4db-f134f98157c2"}},
                 private: %Envelope.Private{personalised_route: true, personalised_request: true}
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
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews",
                   origin: ^mozart_news_endpoint,
                   personalised_route: false,
                   personalised_request: false
                 }
               },
               {:replace, ["CircuitBreaker"]}
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{path_params: %{"id" => "cdr8nnnw9ngt", "slug" => "some-slug"}},
                 private: %Envelope.Private{personalised_route: true, personalised_request: true}
               })
    end

    test "if the id is a Topic ID and is not in the Mozart allowlist, a redirect will be issued without the slug" do
      assert {:stop,
              %Envelope{
                response: %Envelope.Response{
                  http_status: 301,
                  headers: %{
                    "location" => "/news/topics/cl16knzkz9yt",
                    "x-bbc-no-scheme-rewrite" => "1",
                    "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                  },
                  body: "Redirecting"
                }
              }} =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{
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
             %Envelope{
               private: %Envelope.Private{
                 platform: "MozartNews",
                 origin: ^mozart_news_endpoint,
                 personalised_route: false,
                 personalised_request: false
               }
             },
             {:replace, ["CircuitBreaker"]}
           } =
             NewsTopicsPlatformDiscriminator.call(%Envelope{
               request: %Envelope.Request{
                 path_params: %{"id" => "62d838bb-2471-432c-b4db-f134f98157c2", "slug" => "cybersecurity"}
               },
               private: %Envelope.Private{personalised_route: true, personalised_request: true}
             })
  end
end
