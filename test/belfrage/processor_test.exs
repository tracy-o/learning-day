defmodule Belfrage.ProcessorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Processor, Struct}
  alias Belfrage.Struct

  describe "Processor.get_loop/1" do
    @struct %Struct{private: %Struct.Private{loop_id: "SportVideos"}}

    test "adds loop information to Struct.private" do
      assert %Struct{
               request: _request,
               private: %Struct.Private{
                 loop_id: "SportVideos",
                 origin: origin,
                 counter: counter,
                 pipeline: pipeline
               }
             } = Processor.get_loop(@struct)

      assert origin != nil, "Expected an origin value to be provided by the loop"
      assert counter != nil, "Expected a counter value to be provided by the loop"
      assert pipeline != nil, "Expected a pipeline value to be provided by the loop"
    end
  end

  describe "Processor.request_pipeline/1" do
    @struct %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        pipeline: ["MyTransformer1"]
      }
    }

    test "runs struct through transformers" do
      assert %{
               request: _request,
               private: _private,
               sample_change: "foo"
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.request_pipeline/1 with empty pipeline" do
    @struct %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        pipeline: []
      }
    }

    test "returns the unmodified struct" do
      assert %{
               request: _request,
               private: _private
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.init_post_response_pipeline/1" do
    @resp_struct %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/"
      },
      response: %Struct.Response{body: :zlib.gzip("a response"), http_status: 501}
    }

    test "increments status" do
      Belfrage.LoopsRegistry.find_or_start(@resp_struct)
      Processor.init_post_response_pipeline(@resp_struct)

      assert {:ok,
              %{
                counter: %{"https://origin.bbc.co.uk/" => %{501 => 1, :errors => 1}}
              }} = Belfrage.Loop.state(@resp_struct)
    end
  end

  describe "Processor.response_pipeline/1" do
    @resp_struct %Struct{
      response: %Struct.Response{
        http_status: 501,
        body: "",
        headers: %{
          "connection" => "close"
        }
      }
    }

    test "calls the ResponseHeaderGuardian response transformer" do
      result = Processor.response_pipeline(@resp_struct)

      refute Map.has_key?(result.response.headers, "connection")
    end
  end
end
