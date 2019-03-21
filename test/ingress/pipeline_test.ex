defmodule Ingress.Transformers.MockTransformer do
  use Ingress.Transformers.Transformer

  @impl true
  def call(_rest, struct), do: {:ok, struct}
end


defmodule Ingress.PipelineTest do
  use ExUnit.Case

  alias Ingress.Pipeline, as: Subject

  test "process producing a successful response" do
    pipeline = ["MockTransformer"]
    original_struct = %{private: %{req_pipeline: pipeline}, debug: %{pipeline_tail: []}}

    assert {:ok, struct} = Subject.process(original_struct)
  end

  test "process producing an error response" do
    pipeline = ["MyTransformer3"]
    original_struct = %{private: %{req_pipeline: pipeline}, debug: %{pipeline_tail: []}}

    assert {:error, struct, msg} = Subject.process(original_struct)
  end
end
