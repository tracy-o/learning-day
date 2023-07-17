defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Mock

  alias Belfrage.Envelope
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.PreflightTransformers.AssetTypePlatformSelector

  @path "/some/path"
  @service "AresData"

  test_with_mock(
    "returns MozartNews platform if origin returns preflight_data_error",
    PreflightService,
    call: fn %Envelope{}, @service -> {:error, :preflight_data_error} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MozartNews", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns Webcore platform if origin response contains a Webcore asset type",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, "STY"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns MozartNews platform if origin response does not contain a Webcore asset type",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, "IDX"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MozartNews", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns MozartNews platform if origin response contains a 404 status code",
    PreflightService,
    call: fn %Envelope{}, @service -> {:error, :preflight_data_not_found} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: @path}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "MozartNews", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns MozartNews platform and does not make data request if dial is off",
    PreflightService,
    call: fn %Envelope{}, @service -> {:error, :preflight_data_not_found} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "off")

    request = %Envelope.Request{path: @path}
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
end
