defmodule Belfrage.PipelineTest do
  use ExUnit.Case

  alias Belfrage.Pipeline, as: Subject
  alias Belfrage.Struct

  test "process producing a successful response" do
    original_struct = %Struct{private: %Struct.Private{pipeline: ["MockTransformer"]}}

    assert {:ok, struct} = Subject.process(original_struct)
    assert_received(:mock_transformer_called)
  end

  test "when pipeline is stopped, no more transformers are called" do
    original_struct = %Struct{private: %Struct.Private{pipeline: ["MockTransformerStop", "MockTransformer"]}}

    assert {:ok, struct} = Subject.process(original_struct)
    assert_received(:mock_transformer_stop_called)
    refute_received(:mock_transformer_called)
  end

  test "when redirect is issued from the pipeline, no more transformers are called" do
    original_struct = %Struct{private: %Struct.Private{pipeline: ["MockTransformerRedirect", "MockTransformer"]}}

    assert {:ok, struct} = Subject.process(original_struct)
    assert_received(:mock_transformer_redirect_called)
    refute_received(:mock_transformer_called)
  end

  test "process producing an error response" do
    original_struct = %Struct{private: %Struct.Private{pipeline: ["MyTransformer3"]}}

    assert {:error, struct, msg} = Subject.process(original_struct)
  end
end
