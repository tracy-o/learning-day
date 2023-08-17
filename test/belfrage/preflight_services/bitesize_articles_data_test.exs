defmodule Belfrage.PreflightServices.BitesizeArticlesDataTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Private
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1, clear_preflight_metadata_cache: 0]
  alias Belfrage.Behaviours.PreflightService

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @url @fabl_endpoint <> "/module/education-metadata?id=zd27xbk&preflight=true&service=bitesize&type=article"
  @service "BitesizeArticlesData"

  @envelope %Belfrage.Envelope{
    request: %Envelope.Request{path: "/bitesize/articles/:id", path_params: %{"id" => "zd27xbk"}}
  }

  setup :clear_preflight_metadata_cache

  describe "call/2" do
    test "returns empty phase only if response is successful and does not contain phase or topic of study" do
      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: """
            {
              "data": {
                "phase": {},
                "tags": [
                  "Support",
                  "Parenting"
                ],
                "topicOfStudy": {}
              }
            }
           """
         }}
      end)

      assert {:ok,
              %Envelope{
                private: %Private{preflight_metadata: %{@service => %{phase: %{}}}}
              }} = PreflightService.call(@envelope, @service)
    end

    test "returns phase and topic of study if response is successful and contains phase and topic of study" do
      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: """
            {
                "data": {
                  "tags": [
                    "Support",
                    "Starting primary school"
                  ],
                  "topicOfStudy": {
                    "id": "zhtcvk7"
                  },
                  "phase": {
                    "id": "zvbc87h",
                    "label": "Primary"
                  }
                }
            }
           """
         }}
      end)

      assert {:ok,
              %Envelope{
                private: %Private{
                  preflight_metadata: %{
                    @service => %{
                      topic_of_study: "zhtcvk7",
                      phase: "Primary"
                    }
                  }
                }
              }} = PreflightService.call(@envelope, @service)
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
  end
end
