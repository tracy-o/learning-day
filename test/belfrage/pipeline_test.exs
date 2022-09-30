defmodule Belfrage.PipelineTest do
  use ExUnit.Case

  alias Belfrage.Pipeline, as: Subject
  alias Belfrage.Struct

  test "process producing a successful response" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: ["MockTransformer"]}}

    assert {:ok, _struct} = Subject.process(original_struct, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_called)
  end

  test "when pipeline is stopped, no more transformers are called" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: ["MockTransformerStop", "MockTransformer"]}}

    assert {:ok, _struct} = Subject.process(original_struct, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_stop_called)
    refute_received(:mock_transformer_called)
  end

  test "when redirect is issued from the pipeline, no more transformers are called" do
    original_struct = %Struct{
      private: %Struct.Private{request_pipeline: ["MockTransformerRedirect", "MockTransformer"]}
    }

    assert {:ok, _struct} = Subject.process(original_struct, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_redirect_called)
    refute_received(:mock_transformer_called)
  end

  test "process producing an error response" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: ["MyTransformer3"]}}

    assert {:error, _struct, _msg} = Subject.process(original_struct, original_struct.private.request_pipeline)
  end
end
