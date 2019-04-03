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

  describe "Processor.req_pipeline/1" do
    @struct StructHelper.build(
              private: %{
                loop_id: "example_loop_id",
                origin: "https://origin.bbc.co.uk/",
                counter: %{},
                pipeline: ["MyTransformer1"]
              }
            )

    test "runs struct through transformers" do
      assert =
        %{
          request: _request,
          private: _private,
          sample_change: "foo"
        } = Processor.req_pipeline(@struct)
    end
  end
end
