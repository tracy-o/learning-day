defmodule Ingress.Transformers.MyTransformer3Test do
  use ExUnit.Case

  alias Ingress.Transformers.MyTransformer3, as: Subject

  test 'call will return an error' do
    original_struct = %{private: %{req_pipeline: ["MyTransformer3"]}, debug: %{pipeline_trail: []}}
    assert {:error, original_struct, error_msg} = Subject.call([], original_struct)
    assert error_msg == error_msg
  end
end
