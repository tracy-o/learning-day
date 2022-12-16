defmodule Belfrage.RequestTransformers.MyTransformer3Test do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.MyTransformer3, as: Subject
  alias Belfrage.Struct

  @original_struct %Struct{
    private: %{
      request_pipeline: ["MyTransformer3"]
    }
  }

  test 'call will return an error' do
    assert {
             :error,
             _original_struct,
             "error processing pipeline, I'm doing something specific with this"
           } = Subject.call(@original_struct)
  end
end
