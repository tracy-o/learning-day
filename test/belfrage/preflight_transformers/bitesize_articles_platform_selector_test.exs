defmodule Belfrage.PreflightTransformers.BitesizeArticlesPlatformSelectorTest do
  use ExUnit.Case
  import Mock

  alias Belfrage.PreflightTransformers.BitesizeArticlesPlatformSelector
  alias Belfrage.{Envelope, Envelope.Private}
  alias Belfrage.Behaviours.PreflightService

  @path "/bitesize/articles/zgd682p"
  @service "BitesizeArticlesData"

  @mocked_envelope %Envelope{
    private: %Envelope.Private{production_environment: "test"},
    request: %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
  }

  describe "request with an article id" do
    test_with_mock(
      "returns error tuple if env=test and preflight data service returns data error",
      PreflightService,
      call: fn %Envelope{}, @service -> {:error, @mocked_envelope, :preflight_data_error} end
    ) do
      request = %Envelope.Request{path: @path}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) == {:error, @mocked_envelope, 500}
    end

    test_with_mock(
      "selects Morph Router if env=test and preflight data service returns data not found error",
      PreflightService,
      call: fn %Envelope{}, @service -> {:error, @mocked_envelope, :preflight_data_not_found} end
    ) do
      request = %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) ==
               {:ok,
                %Envelope{
                  request: request,
                  private: %Private{
                    platform: "MorphRouter",
                    production_environment: "test",
                    preflight_metadata: %{}
                  }
                }}
    end

    test "selects WebCore if env=test and article id is in webcore_ids" do
      request = %Envelope.Request{path: @path, path_params: %{"id" => "zgd682p"}}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) ==
               {:ok,
                %Envelope{
                  request: request,
                  private: %Private{
                    platform: "Webcore",
                    production_environment: "test",
                    preflight_metadata: %{}
                  }
                }}
    end

    test_with_mock(
      "selects WebCore if env=test and preflight data article returns no phase",
      PreflightService,
      call: fn %Envelope{}, @service ->
        {:ok,
         Envelope.add(@mocked_envelope, :private, %{
           preflight_metadata: %{@service => %{phase: %{}}}
         })}
      end
    ) do
      request = %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) ==
               {:ok,
                %Envelope{
                  request: request,
                  private: %Private{
                    platform: "Webcore",
                    production_environment: "test",
                    preflight_metadata: %{@service => %{phase: %{}}}
                  }
                }}
    end

    test_with_mock(
      "selects MorphRouter if env=test and preflight data article returns a phase label",
      PreflightService,
      call: fn %Envelope{}, @service ->
        {:ok,
         Envelope.add(@mocked_envelope, :private, %{
           preflight_metadata: %{@service => %{phase: "Primary"}}
         })}
      end
    ) do
      request = %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) ==
               {:ok,
                %Envelope{
                  request: request,
                  private: %Private{
                    platform: "MorphRouter",
                    production_environment: "test",
                    preflight_metadata: %{@service => %{phase: "Primary"}}
                  }
                }}
    end

    test_with_mock(
      "selects webcore and preflight data article returns a Post-16 phase label",
      PreflightService,
      call: fn %Envelope{}, @service ->
        {:ok,
         Envelope.add(@mocked_envelope, :private, %{
           preflight_metadata: %{@service => %{phase: "Post-16"}}
         })}
      end
    ) do
      request = %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) ==
               {:ok,
                %Envelope{
                  request: request,
                  private: %Private{
                    platform: "Webcore",
                    production_environment: "test",
                    preflight_metadata: %{@service => %{phase: "Post-16"}}
                  }
                }}
    end

    test "selects Webcore if env=live and the article id is a live webcore id" do
      request = %Envelope.Request{path: @path, path_params: %{"id" => "zj8yydm"}}
      private = %Envelope.Private{production_environment: "live"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeArticlesPlatformSelector.call(envelope) ==
               {:ok,
                %Envelope{
                  request: request,
                  private: %Private{
                    platform: "Webcore",
                    production_environment: "live",
                    preflight_metadata: %{}
                  }
                }}
    end
  end
end
