defmodule Ingress.Transformers.MyTransformer3Test do
  use ExUnit.Case

  alias Ingress.Transformers.MyTransformer3, as: Subject
  alias Test.Support.StructHelper

  @original_struct StructHelper.build(
    private: %{
      pipeline: ["MyTransformer3"]
    }
  )

  test 'call will return an error' do
    assert {
      :error,
      _original_struct,
      "error processing pipeline, I'm doing something specific with this"
    } = Subject.call([], @original_struct)
  end
end
