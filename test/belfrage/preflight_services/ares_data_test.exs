defmodule Belfrage.PreflightServices.AresDataTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.Envelope
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1, clear_preflight_metadata_cache: 0]
  alias Belfrage.Behaviours.PreflightService

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]
  @table_name :preflight_metadata_cache
  @service "AresData"

  @envelope %Belfrage.Envelope{request: %Envelope.Request{path: "/some/path"}}

  setup :clear_preflight_metadata_cache

  describe "fetch/1" do
    test "returns a HTTP Response" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"MAP\"}}"
         }}
      end)

      assert {:ok, "MAP"} = PreflightService.call(@envelope, @service)
    end

    test "stores successful response in cache when asset type in webcore asset types" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      Enum.each(@webcore_asset_types, fn asset_type ->
        clear_preflight_metadata_cache()

        expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
          {:ok,
           %HTTP.Response{
             headers: %{},
             status_code: 200,
             body: "{\"data\": {\"assetType\": \"#{asset_type}\"}}"
           }}
        end)

        assert {:ok, ^asset_type} = PreflightService.call(@envelope, @service)
        assert Cachex.get(@table_name, {@service, "/some/path"}) == {:ok, asset_type}
      end)
    end

    test "stores successful response in cache when asset type not in webcore asset types" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      assert {:ok, "SOME_ASSET_TYPE"} = PreflightService.call(@envelope, @service)
      assert Cachex.get(@table_name, {@service, "/some/path"}) == {:ok, "SOME_ASSET_TYPE"}
    end

    test "does not store successful response in cache when 404 response status code" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 404
         }}
      end)

      assert {:error, :preflight_data_not_found} = PreflightService.call(@envelope, @service)
      assert Cachex.get(@table_name, {@service, "/some/path"}) == {:ok, nil}
    end

    test "does not store successful response in cache when non-200 and non-404 response status code" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 500
         }}
      end)

      assert {:error, :preflight_data_error} = PreflightService.call(@envelope, @service)
      assert Cachex.get(@table_name, {@service, "/some/path"}) == {:ok, nil}
    end

    test "fetches stored successful response from cache" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      assert {:ok, "SOME_ASSET_TYPE"} = PreflightService.call(@envelope, @service)
      assert {:ok, "SOME_ASSET_TYPE"} = PreflightService.call(@envelope, @service)
    end

    test "does not fetch stored successful response from cache after TTL" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      assert {:ok, "SOME_ASSET_TYPE"} = PreflightService.call(@envelope, @service)

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      Process.sleep(Application.get_env(:belfrage, :preflight_metadata_cache)[:default_ttl_ms] + 1)

      assert {:ok, "SOME_ASSET_TYPE"} = PreflightService.call(@envelope, @service)
    end
  end
end
