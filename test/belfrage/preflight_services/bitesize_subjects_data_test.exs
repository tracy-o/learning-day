defmodule Belfrage.PreflightServices.BitesizeSubjectsDataTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.Envelope
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1, clear_preflight_metadata_cache: 0]
  alias Belfrage.Behaviours.PreflightService

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @url @fabl_endpoint <> "/module/education-metadata?id=zgkw2hv&preflight=true&service=bitesize&type=subject"
  @table_name :preflight_metadata_cache
  @service "BitesizeSubjectsData"

  @envelope %Belfrage.Envelope{
    request: %Envelope.Request{path: "/bitesize/subjects/zgkw2hv", path_params: %{"id" => "zgkw2hv"}}
  }

  setup :clear_preflight_metadata_cache

  describe "call/2" do
    test "returns successful response when contains a Primary phase" do
      bitesize_subject_label = "Primary"

      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"phase\": {\"label\": \"#{bitesize_subject_label}\"}}}"
         }}
      end)

      assert {:ok, %Envelope{}, ^bitesize_subject_label} = PreflightService.call(@envelope, @service)

      assert Cachex.get(@table_name, {"BitesizeSubjectsData", "/bitesize/subjects/zgkw2hv"}) ==
               {:ok, bitesize_subject_label}
    end

    test "returns successful response when contains a non-Primary phase" do
      bitesize_subject_label = "Secondary"

      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"phase\": {\"label\": \"#{bitesize_subject_label}\"}}}"
         }}
      end)

      assert {:ok, %Envelope{}, ^bitesize_subject_label} = PreflightService.call(@envelope, @service)

      assert Cachex.get(@table_name, {"BitesizeSubjectsData", "/bitesize/subjects/zgkw2hv"}) ==
               {:ok, bitesize_subject_label}
    end

    test "returns empty label if phase is empty object" do
      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"phase\": {}}}"
         }}
      end)

      assert {:ok, %Envelope{}, ""} = PreflightService.call(@envelope, @service)
    end

    test "returns not found when returns a 404" do
      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 404,
           body: ""
         }}
      end)

      assert {:error, %Envelope{}, :preflight_data_not_found} = PreflightService.call(@envelope, @service)
    end

    test "returns :preflight_data_error if phase contains a key other than label" do
      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "{\"data\": {\"phase\": {\"some_key\": \"some_value\"}}}"
         }}
      end)

      assert {:error, %Envelope{}, :preflight_data_error} = PreflightService.call(@envelope, @service)
    end

  end
end
