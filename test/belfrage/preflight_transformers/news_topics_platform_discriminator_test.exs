defmodule Belfrage.PreflightTransformers.NewsTopicsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.NewsTopicsPlatformDiscriminator
  alias Belfrage.Envelope

  setup do
    stub_dials(webcore_kill_switch: "inactive", circuit_breaker: "false")
  end

  describe "when the ID is a Topic and the ID is in the Mozart allowlist" do
    test "it returns an envelope with MozartNews as the platform" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{path_params: %{"id" => "cdr8nnnw9ngt"}},
                 private: %Envelope.Private{personalised_route: true, personalised_request: true}
               })
    end
  end

  describe "when the ID is a Topic ID but the ID is NOT in the Mozart allowlist" do
    test "it doesn't change the platform" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "BBCX"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 private: %Envelope.Private{
                   platform: "BBCX"
                 },
                 request: %Envelope.Request{
                   path_params: %{"id" => "some-id"}
                 }
               })
    end
  end

  describe "when the ID is a GUID" do
    test "it returns MozartNews as the platform" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{path_params: %{"id" => "62d838bb-2471-432c-b4db-f134f98157c2"}},
                 private: %Envelope.Private{platform: "Webcore", personalised_route: true, personalised_request: true}
               })
    end
  end

  describe "when the path contains a slug, the ID is a TOPIC and is in the Mozart allowlist" do
    test "it returns MozartNews as the platform" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{path_params: %{"id" => "cdr8nnnw9ngt", "slug" => "some-slug"}},
                 private: %Envelope.Private{personalised_route: true, personalised_request: true}
               })
    end
  end

  describe "when the path has a slug, the ID is a Topic ID but is not in the Mozart allowlist" do
    test "it issues a redirect without the slug" do
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

  describe "when the path has a slug and the ID is a GUID" do
    test "it returns MozartNews as the platform" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "MozartNews"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{
                   path_params: %{"id" => "62d838bb-2471-432c-b4db-f134f98157c2", "slug" => "cybersecurity"}
                 },
                 private: %Envelope.Private{personalised_route: true, personalised_request: true}
               })
    end
  end

  describe "when not a mozart topic, not a GUID, and does not have a slug" do
    test "it returns the original envelope" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "Webcore",
                   personalised_route: true,
                   personalised_request: true
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{
                   path_params: %{"id" => "62d838bb-2471"}
                 },
                 private: %Envelope.Private{platform: "Webcore", personalised_route: true, personalised_request: true}
               })
    end
  end

  describe "when not a mozart topic, not a GUID, does not have a slug, and the platform is nil" do
    test "it puts Webcore as the platform if there isn't one" do
      assert {
               :ok,
               %Envelope{
                 private: %Envelope.Private{
                   platform: "Webcore"
                 }
               }
             } =
               NewsTopicsPlatformDiscriminator.call(%Envelope{
                 request: %Envelope.Request{
                   path_params: %{"id" => "62d838bb-2471"}
                 },
                 private: %Envelope.Private{platform: nil}
               })
    end
  end
end
