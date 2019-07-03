defmodule Belfrage.Transformers.MyTransformer1Test do
  use ExUnit.Case

  alias Belfrage.Transformers.MyTransformer1, as: Subject
  alias Test.Support.StructHelper

  @original_struct StructHelper.build(
                     private: %{
                       pipeline: ["MyTransformer1"]
                     }
                   )

  test 'call with no remaining transformers' do
    pipeline = ["MyTransformer1"]
    {:ok, next_struct} = Subject.call(pipeline, @original_struct)

    assert next_struct.sample_change == "foo"
    assert next_struct.debug.pipeline_trail == pipeline
  end

  test 'call with remaining transformers' do
    pipeline = ["MyTransformer1", "MockTransformer"]
    {:ok, next_struct} = Subject.call(pipeline, @original_struct)

    assert next_struct.sample_change == "foo"
    assert next_struct.debug.pipeline_trail == Enum.reverse(pipeline)
  end
end
