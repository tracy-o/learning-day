Code.require_file("test/mocks/mock_transformer.ex")

defmodule Ingress.Transformers.MyTransformer1Test do
  use ExUnit.Case

  alias Ingress.Transformers.MyTransformer1, as: Subject

  test 'call with no remaining transformers' do
    pipeline = ["MyTransformer1"]
    original_struct = %{private: %{req_pipeline: pipeline}, debug: %{pipeline_trail: []}}
    {:ok, next_struct} = Subject.call(pipeline, original_struct)

    assert next_struct.sample_change == "foo"
    assert next_struct.debug.pipeline_trail == pipeline
  end

  test 'call with remaining transformers' do
    pipeline = ["MyTransformer1", "MockTransformer"]
    original_struct = %{private: %{req_pipeline: pipeline}, debug: %{pipeline_trail: []}}
    {:ok, next_struct} = Subject.call(pipeline, original_struct)

    assert next_struct.sample_change == "foo"
    assert next_struct.debug.pipeline_trail == Enum.reverse(pipeline)
  end
end
