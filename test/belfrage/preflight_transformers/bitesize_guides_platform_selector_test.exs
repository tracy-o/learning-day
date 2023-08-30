defmodule Belfrage.PreflightTransformers.BitesizeGuidesPlatformSelectorTest do
  use ExUnit.Case
  import Mock

  alias Belfrage.PreflightTransformers.BitesizeGuidesPlatformSelector
  alias Belfrage.{Envelope, Envelope.Private}
  alias Belfrage.Behaviours.PreflightService

  @path "/bitesize/guides/z2synbk/revision/1"
  @service "BitesizeGuidesData"

  @mocked_envelope %Envelope{
    private: %Envelope.Private{production_environment: "test"},
    request: %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
  }

  defp assert_platform(expected_platform, exam_specification) do
    request = %Envelope.Request{path: @path, path_params: %{"id" => "some_id"}}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeGuidesPlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                request: request,
                private: %Private{
                  platform: expected_platform,
                  production_environment: "test",
                  preflight_metadata: %{@service => %{exam_specification: exam_specification}}
                }
              }}
  end

  describe "requests with an id parameter key" do
    test_with_mock(
      "selects WebCore if preflight data guide returns an examSpecification and examSpecificationId is in examspec allowed ids list",
      PreflightService,
      call: fn %Envelope{}, @service ->
        {:ok,
         Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => %{exam_specification: "z2synbk"}}})}
      end
    ) do
      assert_platform("Webcore", "z2synbk")
    end

    test_with_mock(
      "selects Morph if preflight data guide returns an examSpecification and examSpecificationId is not examspec allowed ids list",
      PreflightService,
      call: fn %Envelope{}, @service ->
        {:ok,
         Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => %{exam_specification: "z2sy123"}}})}
      end
    ) do
      assert_platform("MorphRouter", "z2sy123")
    end

    test_with_mock(
      "selects Morph if preflight data guide returns an empty examSpecification",
      PreflightService,
      call: fn %Envelope{}, @service ->
        {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => %{exam_specification: ""}}})}
      end
    ) do
      assert_platform("MorphRouter", "")
    end

    test_with_mock(
      "returns 404 if preflight data service returns preflight_data_not_found",
      PreflightService,
      call: fn %Envelope{}, @service -> {:error, @mocked_envelope, :preflight_data_not_found} end
    ) do
      request = %Envelope.Request{path: @path}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeGuidesPlatformSelector.call(envelope) == {:error, @mocked_envelope, 404}
    end

    test_with_mock(
      "returns 500 if preflight data service returns preflight_data_error",
      PreflightService,
      call: fn %Envelope{}, @service -> {:error, @mocked_envelope, :preflight_data_error} end
    ) do
      request = %Envelope.Request{path: @path}
      private = %Envelope.Private{production_environment: "test"}
      envelope = %Envelope{request: request, private: private}

      assert BitesizeGuidesPlatformSelector.call(envelope) == {:error, @mocked_envelope, 500}
    end
  end
end
