defmodule Routes.Platforms.Selectors.Fetchers.AresDataTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.Clients.{HTTP, HTTPMock}
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1, clear_preflight_metadata_cache: 0]
  alias Routes.Platforms.Selectors.Fetchers.AresData

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]
  @table_name :preflight_metadata_cache

  setup :clear_preflight_metadata_cache

  describe "fetch_metadata/1" do
    test "returns a HTTP Response" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"MAP\"}}"
         }}
      end)

      AresData.fetch_metadata("/some/path")
    end

    test "stores successful response in cache when asset type in webcore asset types" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      Enum.each(@webcore_asset_types, fn asset_type ->
        clear_preflight_metadata_cache()

        expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
          {:ok,
           %HTTP.Response{
             headers: %{},
             status_code: 200,
             body: "{\"data\": {\"assetType\": \"#{asset_type}\"}}"
           }}
        end)

        assert {:ok, ^asset_type} = AresData.fetch_metadata("/some/path")
        assert Cachex.get(@table_name, {"AresData", "/some/path"}) == {:ok, asset_type}
      end)
    end

    test "stores successful response in cache when asset type not in webcore asset types" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      assert {:ok, "SOME_ASSET_TYPE"} = AresData.fetch_metadata("/some/path")
      assert Cachex.get(@table_name, {"AresData", "/some/path"}) == {:ok, "SOME_ASSET_TYPE"}
    end

    test "does not store successful response in cache when 404 response status code" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 404
         }}
      end)

      assert {:error,
              %HTTP.Response{
                headers: %{},
                status_code: 404
              }} = AresData.fetch_metadata("/some/path")

      assert Cachex.get(@table_name, {"AresData", "/some/path"}) == {:ok, nil}
    end

    test "does not store successful response in cache when non-200 and non-404 response status code" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 500
         }}
      end)

      assert {:error,
              %HTTP.Response{
                headers: %{},
                status_code: 500
              }} = AresData.fetch_metadata("/some/path")

      assert Cachex.get(@table_name, {"AresData", "/some/path"}) == {:ok, nil}
    end

    test "fetches stored successful response from cache" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      assert {:ok, "SOME_ASSET_TYPE"} = AresData.fetch_metadata("/some/path")
      assert {:ok, "SOME_ASSET_TYPE"} = AresData.fetch_metadata("/some/path")
    end

    test "does not fetch stored successful response from cache after TTL" do
      url = @fabl_endpoint <> "/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      assert {:ok, "SOME_ASSET_TYPE"} = AresData.fetch_metadata("/some/path")

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Fabl ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"assetType\": \"SOME_ASSET_TYPE\"}}"
         }}
      end)

      Process.sleep(Application.get_env(:belfrage, :preflight_metadata_cache)[:default_ttl_ms] + 1)

      assert {:ok, "SOME_ASSET_TYPE"} = AresData.fetch_metadata("/some/path")
    end
  end
end
