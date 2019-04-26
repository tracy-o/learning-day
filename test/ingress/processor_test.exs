defmodule Ingress.ProcessorTest do
  use ExUnit.Case

  alias Ingress.{Processor, Struct}
  alias Test.Support.StructHelper

  describe "Processor.get_loop/1" do
    @struct StructHelper.build(private: %{loop_id: "example_loop_id"})

    test "adds loop information to Struct.private" do
      assert %Struct{
               request: _request,
               private: %Struct.Private{
                 loop_id: "example_loop_id",
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
    @struct StructHelper.build(
              private: %{
                loop_id: "example_loop_id",
                origin: "https://origin.bbc.co.uk/",
                counter: %{},
                pipeline: ["MyTransformer1"]
              }
            )

    test "runs struct through transformers" do
      assert %{
               request: _request,
               private: _private,
               sample_change: "foo"
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.response_pipeline/1" do
    @resp_struct StructHelper.build(
              private: %{loop_id: "example_loop_id"},
              response: %{http_status: "200"}
            )
    
    test "increments status" do 
      Ingress.LoopsRegistry.find_or_start(@resp_struct)
      Processor.response_pipeline(@resp_struct)
      assert {:ok, 
        %{
          counter: %{"200" => 1}
        }
      } = Ingress.Loop.state(@resp_struct)
    end
  end
end
