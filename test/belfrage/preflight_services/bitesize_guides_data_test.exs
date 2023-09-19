defmodule Belfrage.PreflightServices.BitesizeGuidesDataTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Private
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1, clear_preflight_metadata_cache: 0]
  alias Belfrage.Behaviours.PreflightService

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @url @fabl_endpoint <> "/module/education-metadata?id=ztmktv4&preflight=true&service=bitesize&type=guide"
  @service "BitesizeGuidesData"
  @table_name :preflight_metadata_cache

  @envelope %Belfrage.Envelope{
    request: %Envelope.Request{
      path: "/bitesize/guides/:id/revision/:page",
      path_params: %{"id" => "ztmktv4"}
    }
  }

  setup :clear_preflight_metadata_cache

  describe "call/2" do
    test "returns examspecification id if examSpecification exists for guide" do
      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: """
            {
              "data": {
                "topicOfStudy": {
                  "id": "z337cj6"
                },
                "examSpecification": {
                  "id": "z2synbk"
                },
                "programmeOfStudy": {
                  "id": "z9ddmp3"
                },
                "phase": {
                  "id": "zc9d7ty",
                  "label": "Secondary"
                },
                "level": {
                  "id": "z98jmp3"
                }
            }
           }
           """
         }}
      end)

      assert {:ok,
              %Envelope{
                private: %Private{preflight_metadata: %{@service => %{exam_specification: "z2synbk", level: "z98jmp3"}}}
              }} = PreflightService.call(@envelope, @service)

      assert Cachex.get(@table_name, {@service, "ztmktv4"}) ==
               {:ok, %{exam_specification: "z2synbk", level: "z98jmp3"}}
    end

    test "returns empty examSpecification if examSpecification does not exist for guide" do
      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: """
            {
              "data": {
                "topicOfStudy": {
                  "id": "z7tp34j"
                },
                "examSpecification": {
                },
                "programmeOfStudy": {
                  "id": "zvc9q6f"
                },
                "phase": {
                  "id": "zc9d7ty",
                  "label": "Secondary"
                },
                "level": {
                  "id": "z4kw2hv"
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
                      exam_specification: "",
                      level: "z4kw2hv"
                    }
                  }
                }
              }} = PreflightService.call(@envelope, @service)
    end

    test "returns empty level and empty examSpec if level id and exam spec id does not exist for guide" do
      clear_preflight_metadata_cache()

      expect(HTTPMock, :execute, fn %HTTP.Request{url: @url}, :Preflight ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: """
            {
              "data": {
                "topicOfStudy": {
                  "id": "z7tp34j"
                },
                "examSpecification": {
                },
                "programmeOfStudy": {
                  "id": "zvc9q6f"
                },
                "phase": {
                  "id": "zc9d7ty",
                  "label": "Secondary"
                },
                "level": {
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
                      exam_specification: "",
                      level: ""
                    }
                  }
                }
              }} = PreflightService.call(@envelope, @service)
    end

    test "returns not found when module returns a 404" do
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
