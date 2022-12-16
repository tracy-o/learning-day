defmodule Belfrage.PipelineTest do
  use ExUnit.Case

  alias Belfrage.Pipeline
  alias Belfrage.Struct

  test "process producing a successful response" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: ["MockTransformer"]}}

    assert {:ok, struct} = Pipeline.process(original_struct, :request, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_called)
    assert_pipeline_trail(struct, ["MockTransformer"])
  end

  test "process producing a successful response that adds new transformer to the pipeline" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: [MockTransformerAdd, MockTransformerStop]}}

    assert {:ok, struct} = Pipeline.process(original_struct, :request, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_add_called)
    assert_received(:mock_transformer_called)
    assert_received(:mock_transformer_stop_called)
    assert_pipeline_trail(struct, [MockTransformerStop, MockTransformer, MockTransformerAdd])
  end

  test "process producing a successful response that replaces the pipeline with new transformer" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: [MockTransformerReplace, MockTransformerStop]}}

    assert {:ok, struct} = Pipeline.process(original_struct, :request, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_replace_called)
    assert_received(:mock_transformer_called)
    refute_received(:mock_transformer_stop_called)
    assert_pipeline_trail(struct, [MockTransformer, MockTransformerReplace])
  end

  test "when pipeline is stopped, no more transformers are called" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: ["MockTransformerStop", "MockTransformer"]}}

    assert {:ok, struct} = Pipeline.process(original_struct, :request, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_stop_called)
    refute_received(:mock_transformer_called)
    assert_pipeline_trail(struct, ["MockTransformerStop"])
  end

  test "when redirect is issued from the pipeline, no more transformers are called" do
    original_struct = %Struct{
      private: %Struct.Private{request_pipeline: ["MockTransformerRedirect", "MockTransformer"]}
    }

    assert {:ok, struct} = Pipeline.process(original_struct, :request, original_struct.private.request_pipeline)
    assert_received(:mock_transformer_redirect_called)
    refute_received(:mock_transformer_called)
    assert_pipeline_trail(struct, ["MockTransformerRedirect"])
  end

  test "process producing an error response" do
    original_struct = %Struct{private: %Struct.Private{request_pipeline: ["MyTransformer3"]}}

    assert {:error, struct, _msg} =
             Pipeline.process(original_struct, :request, original_struct.private.request_pipeline)

    assert_pipeline_trail(struct, ["MyTransformer3"])
  end

  defp assert_pipeline_trail(struct, expected_trail) do
    assert ^expected_trail = struct.debug.request_pipeline_trail
  end
end
