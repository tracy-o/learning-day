defmodule Belfrage.Transformers.AresDataTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Struct, Transformers.AresData, Clients}

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)

  test "does not modify Struct if origin returns 500 http status" do
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

    struct = %Struct{request: %Struct.Request{path: "/some/path"}}

    assert {:ok, ^struct} = AresData.call([], struct)
  end

  test "does not modify Struct if origin response body does not contain section" do
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

    struct = %Struct{request: %Struct.Request{path: "/some/path"}}

    assert {:ok, ^struct} = AresData.call([], struct)
  end

  test "does not modify Struct if origin response body does not contain assetType" do
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

    struct = %Struct{request: %Struct.Request{path: "/some/path"}}

    assert {:ok, ^struct} = AresData.call([], struct)
  end

  test "modifies Struct if origin response body contains assetType and section" do
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

    assert {:ok, %Struct{private: %Struct.Private{metadata: %{asset_type: "STY"}}}} =
             AresData.call([], %Struct{request: %Struct.Request{path: "/some/path"}})
  end
end
