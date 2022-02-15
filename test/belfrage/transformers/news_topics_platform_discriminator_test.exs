defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator
  alias Belfrage.Struct

  setup do
    stub_dials(webcore_kill_switch: "inactive", circuit_breaker: "false")

    :ok
  end

  test "if the Topic ID is not in the Webcore allow list the platform will be altered to Mozart" do
    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 platform: MozartNews
               }
             }
           } =
             NewsTopicsPlatformDiscriminator.call([], %Struct{
               request: %Struct.Request{path_params: %{"id" => "some-id"}}
             })
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
  end
end
