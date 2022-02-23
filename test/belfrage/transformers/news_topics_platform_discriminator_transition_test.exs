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
    test "if the Topic ID is in the Mozart allowlist the platform and origin is Mozart", %{
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
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "c2x6gdkj24kt"}}
               })
    end

    test "if the Topic ID is in not in the Mozart allowlist the platform and origin are unchanged" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   platform: nil,
                   origin: nil
                 }
               }
             } =
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "some-id"}}
               })
    end
  end

  describe "when the path contains a slug" do
    test "if the Topic ID is in the Mozart allowlist the platform and origin will be altered to Mozart News", %{
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
               NewsTopicsPlatformDiscriminatorTransition.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "c2x6gdkj24kt", "slug" => "some-slug"}}
               })
    end

    test "if the Topic ID not in the Mozart allowlist, a redirect will be issued without the slug" do
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
end
