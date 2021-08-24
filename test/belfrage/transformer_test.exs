defmodule Belfrage.Transformers.TransformerTest do
  use ExUnit.Case

  alias Belfrage.Transformers.Transformer, as: Subject
  alias Belfrage.Struct

	test "when there are transformers in the list it will call the next one, seen via the reverse ordering in the debug pipeline trail" do
		struct = %Struct{private: %Struct.Private{pipeline: ["HTTPredirect", "CircuitBreaker"]}}
		output_struct = %Struct{private: %Struct.Debug{pipeline_trail: ["CircuitBreaker", "HTTPredirect"]}}
    assert {:ok, output_struct} = Subject.then(struct.private.pipeline, struct)
	end

	test "when there are no more transformers in the list it returns {:ok, struct}" do
		struct = %Struct{private: %Struct.Private{pipeline: []}}
    assert {:ok, _struct} = Subject.then([], struct)
	end

  test "when the next transformer is :_routespec_pipeline_placeholder it skips it and calls the next one" do
		struct = %Struct{private: %Struct.Private{pipeline: ["HTTPredirect", :_routespec_pipeline_placeholder, "CircuitBreaker"]}}
		output_struct = %Struct{private: %Struct.Debug{pipeline_trail: ["CircuitBreaker", "HTTPredirect"]}}
    assert {:ok, output_struct} = Subject.then(struct.private.pipeline, struct)
  end
end
