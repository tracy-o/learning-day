defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_stack_id: 1]
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
    "returns Webcore platform if origin returns preflight_data_error - all stacks apart from Joan",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:error, @mocked_envelope, :preflight_data_error}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "returns Webcore platform if origin response contains a Webcore asset type",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "STY"}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "returns MozartNews platform if origin response does not contain a Webcore asset type",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "IDX"}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

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
    "makes AresData request when the path matches the regex",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "STY"}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}

    assert_called(PreflightService.call(@request_envelope, "AresData"))
  end

  test_with_mock(
    "returns Webcore and does not make an AresData request when the path is invalid and the stack is not Joan",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, @mocked_envelope, "STY"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: "/news/.invalid", path_params: %{"id" => ".invalid"}}
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
    "returns Webcore and does not make an AresData request when the invalid path has not enough characters and the stack is not Joan",
    PreflightService,
    call: fn %Envelope{}, @service -> {:ok, @mocked_envelope, "STY"} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    request = %Envelope.Request{path: "/news/a", path_params: %{"id" => "a"}}
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
    "returns Webcore platform if origin response contains a 404 status code - all stacks apart from Joan",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:error, @mocked_envelope, :preflight_data_not_found}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "returns Webcore platform and does not make data request if dial is off - all stacks apart from Joan",
    PreflightService,
    call: fn %Envelope{}, @service -> {:error, @mocked_envelope, :preflight_data_not_found} end
  ) do
    stub_dial(:preflight_ares_data_fetch, "off")

    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{platform: "Webcore", production_environment: "test"},
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}

    assert_not_called(PreflightService.call(@request_envelope, "AresData"))
  end

  test_with_mock(
    "returns Webcore platform if origin response contains a MozartNews asset type and dial is set to learning mode on all stacks apart from Joan",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "FIX"}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "learning")

    assert AssetTypePlatformSelector.call(@request_envelope) ==
             {:ok,
              %Envelope{
                private: %Envelope.Private{
                  platform: "Webcore",
                  production_environment: "test",
                  checkpoints: %{preflight_service_request_timing: 576_460_641_580}
                },
                request: %Envelope.Request{path: @path, path_params: %{"id" => "valid+path"}}
              }}
  end

  test_with_mock(
    "returns MozartNews platform if origin response contains a Webcore asset type and dial is set to learning mode on Joan",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "STY"}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "learning")
    set_stack_id("joan")

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
    "returns MozartNews platform if there is no id path parameter - route should never match but covers edge case, just in case",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "STY"}
    end
  ) do
    set_stack_id("joan")

    assert {:ok,
            %Envelope{
              private: %Envelope.Private{platform: "MozartNews"}
            }} =
             AssetTypePlatformSelector.call(%Envelope{
               request: %Envelope.Request{path: @path, path_params: %{}},
               private: %Envelope.Private{
                 production_environment: "test"
               }
             })
  end

  test_with_mock(
    "returns an envelope with an external request latency checkpoint",
    PreflightService,
    call: fn %Envelope{}, @service ->
      {:ok, @mocked_envelope, "STY"}
    end
  ) do
    stub_dial(:preflight_ares_data_fetch, "on")

    {:ok, envelope} = AssetTypePlatformSelector.call(@request_envelope)

    checkpoints = envelope.private.checkpoints

    assert Map.has_key?(checkpoints, :preflight_service_request_timing)
  end
end
