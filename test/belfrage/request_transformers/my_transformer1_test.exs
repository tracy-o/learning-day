defmodule Belfrage.RequestTransformers.MyTransformer1Test do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.MyTransformer1, as: Subject
  alias Belfrage.Envelope

  @original_envelope %Envelope{
    private: %{
      request_pipeline: ["MyTransformer1"]
    }
  }

  test 'call with no remaining transformers' do
    {:ok, next_envelope} = Subject.call(@original_envelope)

    assert next_envelope.sample_change == "foo"
    assert next_envelope.debug.request_pipeline_trail == []
  end

  test 'call with remaining transformers' do
    {:ok, next_envelope} = Subject.call(@original_envelope)

    assert next_envelope.sample_change == "foo"
    assert next_envelope.debug.request_pipeline_trail == []
  end
end
