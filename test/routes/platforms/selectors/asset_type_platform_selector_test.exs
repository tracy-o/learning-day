defmodule Routes.Platforms.Selectors.AssetTypePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Struct, Clients}
  alias Routes.Platforms.Selectors.AssetTypePlatformSelector

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)

  test "raises RuntimeError if origin returns 500 http status" do
    url = "#{@fabl_endpoint}/module/ares-data?path=%2Fsome%2Fpath"

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

    assert_raise RuntimeError,
                 "Elixir.Routes.Platforms.Selectors.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: {:ok, %Belfrage.Clients.HTTP.Response{body: nil, headers: %{}, status_code: 500}}}",
                 fn ->
                   AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"})
                 end
  end

  test "raises RuntimeError if origin response body does not contain section" do
    url = "#{@fabl_endpoint}/module/ares-data?path=%2Fsome%2Fpath"

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok, %Clients.HTTP.Response{status_code: 200, body: "{\"assetType\": \"STY\"}"}}
      end
    )

    assert_raise RuntimeError,
                 "Elixir.Routes.Platforms.Selectors.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: {:error, :no_section}}",
                 fn ->
                   AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"})
                 end
  end

  test "raises RuntimeError if origin response body does not contain assetType" do
    url = "#{@fabl_endpoint}/module/ares-data?path=%2Fsome%2Fpath"

    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Clients.HTTP.Request{
           method: :get,
           url: ^url
         },
         :Fabl ->
        {:ok, %Clients.HTTP.Response{status_code: 200, body: "{\"section\": \"business\"}"}}
      end
    )

    assert_raise RuntimeError,
                 "Elixir.Routes.Platforms.Selectors.AssetTypePlatformSelector could not select platform: %{path: /some/path, reason: {:error, :no_asset_type}}",
                 fn ->
                   AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"})
                 end
  end

  test "returns platform string if payload contains assetType and section" do
    url = "#{@fabl_endpoint}/module/ares-data?path=%2Fsome%2Fpath"

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
           body: "{\"section\": \"business\", \"assetType\": \"STY\"}"
         }}
      end
    )

    assert AssetTypePlatformSelector.call(%Struct.Request{path: "/some/path"}) == Webcore
  end
end
