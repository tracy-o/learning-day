defmodule Belfrage.ProcessorTest do
  use ExUnit.Case

  alias Belfrage.{Processor, Struct}
  alias Test.Support.StructHelper

  describe "Processor.get_loop/1" do
    @struct StructHelper.build(private: %{loop_id: ["example_loop_id"]})

    test "adds loop information to Struct.private" do
      assert %Struct{
               request: _request,
               private: %Struct.Private{
                 loop_id: ["example_loop_id"],
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
                loop_id: ["example_loop_id"],
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

  describe "Processor.init_post_response_side_effects/1" do
    @resp_struct StructHelper.build(
                   private: %{
                     loop_id: ["example_loop_id"],
                     origin: "https://origin.bbc.co.uk/"
                   },
                   response: %{http_status: 501}
                 )

    test "increments status" do
      Belfrage.LoopsRegistry.find_or_start(@resp_struct)
      Processor.init_post_response_side_effects(@resp_struct)

      assert {:ok,
              %{
                counter: %{"https://origin.bbc.co.uk/" => %{501 => 1, :errors => 1}}
              }} = Belfrage.Loop.state(@resp_struct)
    end
  end
end
