defmodule Belfrage.PreflightTransformers.BitesizeArticlesPlatformSelectorTest do
  use ExUnit.Case
  import Mock

  alias Belfrage.PreflightTransformers.BitesizeArticlesPlatformSelector
  alias Belfrage.{Envelope, Envelope.Private}
  alias Belfrage.Behaviours.PreflightService

  @path "/bitesize/articles/zgd682p"
  @service "BitesizeArticlesData"

  defp assert_platform(env, platform, article_id) do
    request = %Envelope.Request{path: @path, path_params: %{"id" => article_id}}
    private = %Envelope.Private{production_environment: env}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeArticlesPlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                request: request,
                private: %Private{platform: platform, production_environment: env}
              }}
  end

  describe "request with an article id" do
    test_with_mock(
      "returns error tuple if env=test and preflight data service returns data error",
      PreflightService,
      call: fn %Envelope{}, @service -> {:error, %Envelope{}, :preflight_data_error} end
    ) do
      request = %Envelope.Request{path: @path}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) == {:error, envelope, 500}
    end

    test_with_mock(
      "returns error tuple if env=test and preflight data service returns data not found error",
      PreflightService,
      call: fn %Envelope{}, @service -> {:error, %Envelope{}, :preflight_data_not_found} end
    ) do
      request = %Envelope.Request{path: @path}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) == {:error, envelope, 404}
    end

    test "selects WebCore if env=test and article id is in webcore_ids" do
      assert_platform("test", "Webcore", "zgd682p")
    end

    test_with_mock(
      "selects WebCore if env=test and preflight data article returns no phase",
      PreflightService,
      call: fn %Envelope{}, @service -> {:ok, %Envelope{}, %{phase: %{}}} end
    ) do
      assert_platform("test", "Webcore", "some_id")
    end

    test_with_mock(
      "selects MorphRouter if env=test and preflight data article returns a phase label",
      PreflightService,
      call: fn %Envelope{}, @service -> {:ok, %Envelope{}, %{phase: %{label: "Primary"}}} end
    ) do
      assert_platform("test", "MorphRouter", "some_id")
    end

    test "selects Webcore if env=live and the article id is a live webcore id" do
      assert_platform("live", "Webcore", "zj8yydm")
    end
  end
end
