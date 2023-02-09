defmodule Belfrage.RequestTransformers.MyTransformer3Test do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.MyTransformer3, as: Subject
  alias Belfrage.Envelope

  @original_envelope %Envelope{
    private: %{
      request_pipeline: ["MyTransformer3"]
    }
  }

  test 'call will return an error' do
    assert {
             :error,
             _original_envelope,
             "error processing pipeline, I'm doing something specific with this"
           } = Subject.call(@original_envelope)
  end
end
