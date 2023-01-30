defmodule Routes.Platforms.Selectors.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Struct, Clients}
  alias Routes.Platforms.Selectors.AssetTypePlatformSelector

  import ExUnit.CaptureLog

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  test "returns error tuple if origin returns 500 http status" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

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
             assert AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"}) == {:error, 500}
           end) =~
             "\"message\":\"Elixir.Routes.Platforms.Selectors.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: %Belfrage.Clients.HTTP.Response{status_code: 500, body: nil, headers: %{}}"
  end

  test "returns error tuple if origin response body does not contain assetType" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

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
             assert AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"}) == {:error, 500}
           end) =~
             "\"message\":\"Elixir.Routes.Platforms.Selectors.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: :no_asset_type}"
  end

  test "returns Webcore platform if origin response contains a Webcore assetType" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

    Enum.each(@webcore_asset_types, fn asset_type ->
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

      assert AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"}) == {:ok, "Webcore"}
    end)
  end

  test "returns MozartNews platform if origin response does not contain a Webcore assetType" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

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

    assert AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"}) == {:ok, "MozartNews"}
  end

  test "returns MozartNews platform if origin response contains a 404 status code" do
    url = "#{@fabl_endpoint}/preview/module/spike-ares-asset-identifier?path=%2Fsome%2Fpath"

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

    assert AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"}) == {:ok, "MozartNews"}
  end
end
