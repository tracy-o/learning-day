defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Envelope, Clients}
  alias Belfrage.PreflightTransformers.AssetTypePlatformSelector

  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1]

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  setup :clear_preflight_metadata_cache

  test "returns error tuple if origin returns 500 http status" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"
    envelope = %Envelope{request: %Envelope.Request{path: "/some/path"}}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok, %Clients.HTTP.Response{status_code: 500}}
      end
    )

    assert capture_log(fn ->
             assert AssetTypePlatformSelector.call(envelope) ==
                      {:error, envelope, 500}
           end) =~
             "\"message\":\"Elixir.Belfrage.PreflightTransformers.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: %Belfrage.Clients.HTTP.Response{status_code: 500, body: nil, headers: %{}}}"
  end

  test "returns error tuple if origin response body does not contain assetType" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"
    envelope = %Envelope{request: %Envelope.Request{path: "/some/path"}}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok,
         %Clients.HTTP.Response{
           status_code: 200,
           body: "{\"data\":{\"section\":\"business\"},\"contentType\":\"application/json; charset=utf-8\"}"
         }}
      end
    )

    assert capture_log(fn ->
             assert AssetTypePlatformSelector.call(envelope) ==
                      {:error, envelope, 500}
           end) =~
             "\"message\":\"Elixir.Belfrage.PreflightTransformers.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: :no_asset_type}"
  end

  test "returns Webcore platform if origin response contains a Webcore assetType" do
    Enum.each(@webcore_asset_types, fn asset_type ->
      path_segment = String.downcase(asset_type)
      url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2F#{path_segment}%2Fpath"
      request = %Envelope.Request{path: "/some/#{path_segment}/path"}

      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Clients.HTTP.Request{
             method: :get,
             url: ^url
           },
           :Fabl ->
          {:ok,
           %Clients.HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"assetType\": \"#{asset_type}\"}}"
           }}
        end
      )

      assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
               {:ok, %Envelope{private: %Envelope.Private{platform: "Webcore"}, request: request}}
    end)
  end

  test "returns MozartNews platform if origin response does not contain a Webcore assetType" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"
    request = %Envelope.Request{path: "/some/path"}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok,
         %Clients.HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_OTHER_ASSET_TYPE\"}}"
         }}
      end
    )

    assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
             {:ok, %Envelope{private: %Envelope.Private{platform: "MozartNews"}, request: request}}
  end

  test "returns cached platform" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"
    request = %Envelope.Request{path: "/some/path"}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok,
         %Clients.HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_OTHER_ASSET_TYPE\"}}"
         }}
      end
    )

    assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
             {:ok, %Envelope{private: %Envelope.Private{platform: "MozartNews"}, request: request}}

    assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
             {:ok, %Envelope{private: %Envelope.Private{platform: "MozartNews"}, request: request}}
  end

  test "does not return cached platform after TTL" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"
    request = %Envelope.Request{path: "/some/path"}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok,
         %Clients.HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_OTHER_ASSET_TYPE\"}}"
         }}
      end
    )

    assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
             {:ok, %Envelope{private: %Envelope.Private{platform: "MozartNews"}, request: request}}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok,
         %Clients.HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_OTHER_ASSET_TYPE\"}}"
         }}
      end
    )

    Process.sleep(Application.get_env(:belfrage, :preflight_metadata_cache)[:default_ttl_ms] + 1)

    assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
             {:ok, %Envelope{private: %Envelope.Private{platform: "MozartNews"}, request: request}}
  end

  test "returns MozartNews platform if origin response contains a 404 status code" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"
    request = %Envelope.Request{path: "/some/path"}

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok,
         %Clients.HTTP.Response{
           status_code: 404
         }}
      end
    )

    assert AssetTypePlatformSelector.call(%Envelope{request: request}) ==
             {:ok, %Envelope{private: %Envelope.Private{platform: "MozartNews"}, request: request}}
  end
end
