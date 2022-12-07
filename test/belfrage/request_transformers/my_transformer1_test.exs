defmodule Belfrage.RequestTransformers.MyTransformer1Test do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.MyTransformer1, as: Subject
  alias Belfrage.Struct

  @original_struct %Struct{
    private: %{
      request_pipeline: ["MyTransformer1"]
    }
  }

  test 'call with no remaining transformers' do
    {:ok, next_struct} = Subject.call(@original_struct)

    assert next_struct.sample_change == "foo"
    assert next_struct.debug.request_pipeline_trail == []
  end

  test 'call with remaining transformers' do
    {:ok, next_struct} = Subject.call(@original_struct)

    assert next_struct.sample_change == "foo"
    assert next_struct.debug.request_pipeline_trail == []
  end
end
