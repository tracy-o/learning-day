Code.require_file("test/mocks/mock_transformer.ex")

defmodule Ingress.PipelineTest do
  use ExUnit.Case

  alias Ingress.Pipeline, as: Subject

  test "process producing a successful response" do
    pipeline = ["MockTransformer"]
    original_struct = %{private: %{req_pipeline: pipeline}, debug: %{pipeline_trail: []}}

    assert {:ok, struct} = Subject.process(original_struct)
  end

  test "process producing an error response" do
    pipeline = ["MyTransformer3"]
    original_struct = %{private: %{req_pipeline: pipeline}, debug: %{pipeline_trail: []}}

    assert {:error, struct, msg} = Subject.process(original_struct)
  end
end
