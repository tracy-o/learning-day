defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Mock

  alias Belfrage.Envelope
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.PreflightTransformers.AssetTypePlatformSelector

  @path "/news/valid+path"
  @service "AresData"
  @mocked_envelope %Envelope{
    request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}},
    private: %Envelope.Private{
      production_environment: "test",
      checkpoints: %{preflight_service_request_timing: 576_460_641_580}
    }
  }

  @request_envelope %Envelope{
    request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}},
    private: %Envelope.Private{
      production_environment: "test"
    }
  }

  test_with_mock(
    "returns 500 if origin returns preflight_data_error",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:error, @mocked_envelope, :preflight_data_error}
    end
  ) do
    assert AssetTypePlatformSelector.call(@request_envelope) == {:error, @mocked_envelope, 500}
  end

  test_with_mock(
    "returns Webcore platform if origin response contains a Webcore asset type",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => "STY"}})}
    end
  ) do
    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  preflight_metadata: %{@service => "STY"},
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "returns MozartNews platform if origin response does not contain a Webcore asset type",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => "IDX"}})}
    end
  ) do
    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "MozartNews",
                  production_environment: "test",
                  preflight_metadata: %{@service => "IDX"},
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "makes AresData request when the path matches the regex",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => "STY"}})}
    end
  ) do
    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  preflight_metadata: %{@service => "STY"},
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}

    assert_called(PreflightService.call(@request_envelope, "AresData"))
  end

  test_with_mock(
    "returns MozartNews and does not make an AresData request when the path is invalid",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => "STY"}})}
    end
  ) do
    request = %Envelope.Request{path: "/news/.invalid", path_params: %{"id" => ".invalid"}}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MozartNews", production_environment: "test"},
                request: request
              }}

    assert_not_called(PreflightService.call(envelope, "AresData"))
  end

  test_with_mock(
    "returns MozartNews and does not make an AresData request when the invalid path has not enough characters",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => "STY"}})}
    end
  ) do
    request = %Envelope.Request{path: "/news/a", path_params: %{"id" => "a"}}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MozartNews", production_environment: "test"},
                request: request
              }}

    assert_not_called(PreflightService.call(envelope, "AresData"))
  end

  test_with_mock(
    "returns Mozartnews if origin response contains a 404 status code",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:error, @mocked_envelope, :preflight_data_not_found}
    end
  ) do
    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "MozartNews",
                  production_environment: "test",
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "returns MozartNews if there is no id path parameter - route should never match but covers edge case, just in case",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "STY"}
    end
  ) do
    request = %Envelope.Request{path: @path, path_params: %{}}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "MozartNews",
                  production_environment: "test"
                },
                request: request
              }}

    assert_not_called(PreflightService.call(envelope, "AresData"))
  end

  test_with_mock(
    "returns an envelope with an external request latency checkpoint",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, Envelope.add(@mocked_envelope, :private, %{preflight_metadata: %{@service => "STY"}})}
    end
  ) do
    {:ok, envelope} = AssetTypePlatformSelector.call(@request_envelope)

    checkpoints = envelope.private.checkpoints

    assert Map.has_key?(checkpoints, :preflight_service_request_timing)
  end
end
