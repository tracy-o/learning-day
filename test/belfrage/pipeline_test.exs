defmodule Belfrage.PipelineTest do
  use ExUnit.Case

  alias Belfrage.Pipeline, as: Subject
  alias Belfrage.Struct

  test "process producing a successful response" do
    original_struct = %Struct{private: %Struct.Private{pipeline: ["MockTransformer"]}}

    assert {:ok, struct} = Subject.process(original_struct)
  end

  test "process producing an error response" do
    original_struct = %Struct{private: %Struct.Private{pipeline: ["MyTransformer3"]}}

    assert {:error, struct, msg} = Subject.process(original_struct)
  end
end
