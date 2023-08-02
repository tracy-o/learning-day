defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_stack_id: 1]
  import Mock

  alias Belfrage.Envelope
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.PreflightTransformers.AssetTypePlatformSelector

  @path "/news/some/valid+path"
  @service "AresData"

  test_with_mock(
    "returns Webcore platform if origin returns preflight_data_error - all stacks apart from Joan",
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
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
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
    "makes AresData request when the path matches the regex",
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

    assert_called(PreflightService.call(envelope, "AresData"))
  end

  test_with_mock(
    "returns Webcore and does not make an AresData request when the path is invalid and the stack is not Joan",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, "STY"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: "/news/some/path/that_is/.invalid"}
    private = %Envelope.Private{production_environment: "test"}
    envelope = %Envelope{request: request, private: private}

    assert AssetTypePlatformSelector.call(envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                # "%2Fnews%2Fsome%2Fpath%2Fthat_is%2F.invalid"
                request: request
              }}

    assert_not_called(PreflightService.call(envelope, "AresData"))
  end

  test_with_mock(
    "returns Webcore platform if origin response contains a 404 status code - all stacks apart from Joan",
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
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                request: request
              }}
  end

  test_with_mock(
    "returns Webcore platform and does not make data request if dial is off - all stacks apart from Joan",
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
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                request: request
              }}

    assert_not_called(PreflightService.call(envelope, "AresData"))
  end

  test_with_mock(
    "returns Webcore platform if origin response contains a MozartNews asset type and dial is set to logging mode on all stacks apart from Joan",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, "FIX"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "learning")

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
    "returns MozartNews platform if origin response contains a Webcore asset type and dial is set to logging mode on Joan",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, "STY"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "learning")
    set_stack_id("joan")

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
end
