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
    call: fn %Envelope{}, @service -> {:error, :preflight_data_error} end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) == {:error, envelope, 500}
  end

  test_with_mock(
    "returns error tuple with 404 if preflight data service returns not found error",
    PreflightService,
    call: fn %Envelope{}, @service -> {:error, :preflight_data_not_found} end
  ) do
    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert BitesizeSubjectsPlatformSelector.call(envelope) == {:error, envelope, 404}
  end

  test_with_mock(
    "returns Webcore for a 200 with Primary as the label",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, "Primary"} end
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
    call: fn %Envelope{}, @service -> {:ok, ""} end
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
    call: fn %Envelope{}, @service -> {:ok, "Secondary"} end
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
    call: fn %Envelope{}, @service -> {:ok, "Primary"} end
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
end
