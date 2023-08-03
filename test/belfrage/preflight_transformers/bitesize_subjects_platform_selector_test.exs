defmodule Belfrage.PreflightTransformers.BitesizeSubjectsPlatformSelectorTest do
  use ExUnit.Case
  import Mock

  alias Belfrage.Envelope
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.PreflightTransformers.BitesizeSubjectsPlatformSelector

  @path "/bitesize/subjects/zmj2n39"
  @service "BitesizeSubjectsData"

  test_with_mock(
    "returns error tuple if preflight data service returns data error",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:error,
       %Envelope{private: %Envelope.Private{production_environment: "test"}, request: %Envelope.Request{path: @path}},
       :preflight_data_error}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) == {:error, envelope, 500}
  end

  test_with_mock(
    "returns error tuple with 404 if preflight data service returns not found error",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:error,
       %Envelope{private: %Envelope.Private{production_environment: "test"}, request: %Envelope.Request{path: @path}},
       :preflight_data_not_found}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) == {:error, envelope, 404}
  end

  test_with_mock(
    "returns Webcore for a 200 with Primary as the label",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok,
       %Envelope{private: %Envelope.Private{production_environment: "test"}, request: %Envelope.Request{path: @path}},
       "Primary"}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns Webcore for a 200 with an empty string as the label",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok,
       %Envelope{private: %Envelope.Private{production_environment: "test"}, request: %Envelope.Request{path: @path}},
       ""}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns MorphRouter for a 200 with Secondary as the label",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok,
       %Envelope{private: %Envelope.Private{production_environment: "test"}, request: %Envelope.Request{path: @path}},
       "Secondary"}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MorphRouter", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns MorphRouter for live environment and does not call data source",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, %Envelope{private: %Envelope.Private{checkpoints: %{preflight_service_request_timing: -576_460_641_580}}},
       "Primary"}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "live"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MorphRouter", production_environment: "live"},
                request: request
              }}

    assert_not_called(PreflightService.call(envelope, "BitesizeSubjectsData"))
  end

  test_with_mock(
    "returns an envelope with an external request latency checkpoint",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, %Envelope{private: %Envelope.Private{checkpoints: %{preflight_service_request_timing: 576_460_641_580}}},
       "STY"}
    end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    {:ok, envelope} = BitesizeSubjectsPlatformSelector.call(envelope)

    checkpoints = envelope.private.checkpoints

    assert Map.has_key?(checkpoints, :preflight_service_request_timing)
  end
end
