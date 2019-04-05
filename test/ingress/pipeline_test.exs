defmodule Ingress.PipelineTest do
  use ExUnit.Case

  alias Ingress.Pipeline, as: Subject
  alias Test.Support.StructHelper

  test "process producing a successful response" do
    original_struct = StructHelper.build(private: %{pipeline: ["MockTransformer"]})

    assert {:ok, struct} = Subject.process(original_struct)
  end

  test "process producing an error response" do
    original_struct = StructHelper.build(private: %{pipeline: ["MyTransformer3"]})

    assert {:error, struct, msg} = Subject.process(original_struct)
  end
end
