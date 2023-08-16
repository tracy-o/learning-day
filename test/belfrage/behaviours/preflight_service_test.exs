defmodule Belfrage.Behaviours.PreflightServiceTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{
    Behaviours.PreflightService,
    Cache,
    Envelope,
    Envelope.Private,
    Envelope.Request
  }

  alias Belfrage.Clients.{
    HTTP,
    HTTPMock
  }

  @service "TestServiceData"
  @url "news/123"
  @metadata "some-payload"

  describe "make call/2 call when preflight service" do
    setup do
      Cachex.clear(:preflight_metadata_cache)
      :ok
    end

    test "returns a successful response" do
      mock_http({:ok, %HTTP.Response{status_code: 200, body: "{\"data\": \"some-payload\"}"}})

      assert {:ok, %Envelope{private: %Private{preflight_metadata: %{@service => @metadata}}}} =
               preflight_service_call()
    end

    test "response is already cached" do
      Cache.PreflightMetadata.put(@service, @url, @metadata)

      assert {:ok, %Envelope{private: %Private{preflight_metadata: %{@service => @metadata}}}} =
               preflight_service_call()
    end

    test "returns 404 error" do
      mock_http({:ok, %HTTP.Response{status_code: 404}})

      assert {:error, %Envelope{private: %Private{preflight_metadata: %{}}}, :preflight_data_not_found} =
               preflight_service_call()
    end

    test "returns timeout" do
      mock_http({:error, :timeout})

      assert {:error, %Envelope{private: %Private{preflight_metadata: %{}}}, :preflight_data_error} =
               preflight_service_call()
    end

    test "returns other error" do
      mock_http({:ok, %HTTP.Response{status_code: 500}})

      assert {:error, %Envelope{private: %Private{preflight_metadata: %{}}}, :preflight_data_error} =
               preflight_service_call()
    end

    test "returns a successful response but decoding fails" do
      mock_http({:ok, %HTTP.Response{status_code: 200, body: "invalid_json"}})

      assert {:error, %Envelope{private: %Private{preflight_metadata: %{}}}, :preflight_data_error} =
               preflight_service_call()
    end

    test "returns a successful response and there is preflight metadata in envelope private" do
      mock_http({:ok, %HTTP.Response{status_code: 200, body: "{\"data\": \"some-payload\"}"}})

      init_envelope = %Envelope{
        request: %Request{path: @url},
        private: %Private{preflight_metadata: %{"OtherTestServiceData" => 123}}
      }

      expected_data = %{
        @service => @metadata,
        "OtherTestServiceData" => 123
      }

      assert {:ok, %Envelope{private: %Private{preflight_metadata: ^expected_data}}} =
               preflight_service_call(init_envelope)
    end
  end

  defp preflight_service_call() do
    preflight_service_call(%Envelope{request: %Request{path: @url}})
  end

  defp preflight_service_call(envelope) do
    PreflightService.call(envelope, @service)
  end

  defp mock_http(expected) do
    expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight -> expected end)
  end
end
