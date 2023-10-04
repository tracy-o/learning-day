defmodule Belfrage.PreflightServices.AresDataTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1]
  import ExUnit.CaptureLog

  alias Belfrage.{
    Behaviours.PreflightService,
    Clients.HTTP,
    Clients.HTTPMock,
    Envelope,
    Envelope.Private
  }

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @service "AresData"

  @envelope %Belfrage.Envelope{request: %Envelope.Request{path: "/some/path"}}

  setup :clear_preflight_metadata_cache

  describe "call/1" do
    test "returns asset type when in the data" do
      url = @fabl_endpoint <> "/module/ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"type\": \"MAP\"}}"
         }}
      end)

      assert {:ok, %Envelope{private: %Private{preflight_metadata: %{@service => "MAP"}}}} =
               PreflightService.call(@envelope, @service)
    end

    test "returns preflight_data_not_found when data returns a 404" do
      url = @fabl_endpoint <> "/module/ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 404
         }}
      end)

      log =
        capture_log(fn ->
          assert {:error, %Envelope{}, :preflight_data_not_found} = PreflightService.call(@envelope, @service)
        end)

      assert log =~
               ~s("service":"AresData","response_status":"404","request_path":"/some/path","preflight_error":"data_not_found")
    end

    test "returns preflight_data_error when data returns a 500" do
      url = @fabl_endpoint <> "/module/ares-asset-identifier?path=%2Fsome%2Fpath"

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 500
         }}
      end)

      log =
        capture_log(fn ->
          assert {:error, %Envelope{}, :preflight_data_error} = PreflightService.call(@envelope, @service)
        end)

      assert log =~
               ~s("service":"AresData","response_status":"500","request_path":"/some/path","reason":"nil","preflight_error":"preflight_unacceptable_status_code")
    end

    test "returns test asset type when query params are testData" do
      envelope = %Belfrage.Envelope{
        request: %Envelope.Request{path: "/some/path", query_params: %{"mode" => "testData"}}
      }

      url = @fabl_endpoint <> "/module/ares-asset-identifier?path=%2Fsome%2Fpath"
      headers = %{"ctx-service-env" => "test"}

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url, headers: ^headers}, :Preflight ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"type\": \"MAP\"}}"
         }}
      end)

      assert {:ok, %Envelope{private: %Private{preflight_metadata: %{@service => "MAP"}}}} =
               PreflightService.call(envelope, @service)
    end

    test "returns test asset type when query_params are previewFABLWithTestData" do
      envelope = %Belfrage.Envelope{
        request: %Envelope.Request{path: "/some/path", query_params: %{"mode" => "previewFABLWithTestData"}}
      }

      url = @fabl_endpoint <> "/module/ares-asset-identifier?path=%2Fsome%2Fpath"
      headers = %{"ctx-service-env" => "test"}

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url, headers: ^headers}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{"ctx-request-env" => "test"},
           status_code: 200,
           body: "{\"data\": {\"type\": \"MAP\"}}"
         }}
      end)

      assert {:ok, %Envelope{private: %Private{preflight_metadata: %{@service => "MAP"}}}} =
               PreflightService.call(envelope, @service)
    end

    test "returns asset type on test" do
      envelope = %Belfrage.Envelope{
        request: %Envelope.Request{path: "/some/path"}
      }

      url = @fabl_endpoint <> "/module/ares-asset-identifier?path=%2Fsome%2Fpath"
      headers = %{}

      expect(HTTPMock, :execute, fn %HTTP.Request{url: ^url, headers: ^headers}, :Preflight ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"type\": \"MAP\"}}"
         }}
      end)

      assert {:ok, %Envelope{private: %Private{preflight_metadata: %{@service => "MAP"}}}} =
               PreflightService.call(envelope, @service)
    end
  end
end
