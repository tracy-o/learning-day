defmodule Belfrage.PipelineTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper

  alias Belfrage.Pipeline
  alias Belfrage.Envelope

  test "process producing a successful response" do
    original_envelope = %Envelope{private: %Envelope.Private{request_pipeline: ["MockTransformer"]}}

    assert {:ok, envelope} = Pipeline.process(original_envelope, :request, original_envelope.private.request_pipeline)
    assert_received(:mock_transformer_called)
    assert_pipeline_trail(envelope, ["MockTransformer"])
  end

  test "process producing a successful response that adds new transformer to the pipeline" do
    original_envelope = %Envelope{
      private: %Envelope.Private{request_pipeline: [MockTransformerAdd, MockTransformerStop]}
    }

    assert {:ok, envelope} = Pipeline.process(original_envelope, :request, original_envelope.private.request_pipeline)
    assert_received(:mock_transformer_add_called)
    assert_received(:mock_transformer_called)
    assert_received(:mock_transformer_stop_called)
    assert_pipeline_trail(envelope, [MockTransformerStop, MockTransformer, MockTransformerAdd])
  end

  test "process producing a successful response that replaces the pipeline with new transformer" do
    original_envelope = %Envelope{
      private: %Envelope.Private{request_pipeline: [MockTransformerReplace, MockTransformerStop]}
    }

    assert {:ok, envelope} = Pipeline.process(original_envelope, :request, original_envelope.private.request_pipeline)
    assert_received(:mock_transformer_replace_called)
    assert_received(:mock_transformer_called)
    refute_received(:mock_transformer_stop_called)
    assert_pipeline_trail(envelope, [MockTransformer, MockTransformerReplace])
  end

  test "when pipeline is stopped, no more transformers are called" do
    original_envelope = %Envelope{
      private: %Envelope.Private{request_pipeline: ["MockTransformerStop", "MockTransformer"]}
    }

    assert {:ok, envelope} = Pipeline.process(original_envelope, :request, original_envelope.private.request_pipeline)
    assert_received(:mock_transformer_stop_called)
    refute_received(:mock_transformer_called)
    assert_pipeline_trail(envelope, ["MockTransformerStop"])
  end

  test "when redirect is issued from the pipeline, no more transformers are called" do
    original_envelope = %Envelope{
      private: %Envelope.Private{request_pipeline: ["MockTransformerRedirect", "MockTransformer"]}
    }

    assert {:ok, envelope} = Pipeline.process(original_envelope, :request, original_envelope.private.request_pipeline)
    assert_received(:mock_transformer_redirect_called)
    refute_received(:mock_transformer_called)
    assert_pipeline_trail(envelope, ["MockTransformerRedirect"])
  end

  test "process producing an error response" do
    original_envelope = %Envelope{private: %Envelope.Private{request_pipeline: ["MyTransformer3"]}}

    assert {:error, envelope, _msg} =
             Pipeline.process(original_envelope, :request, original_envelope.private.request_pipeline)

    assert_pipeline_trail(envelope, ["MyTransformer3"])
  end

  test "return error when response tuple is invalid" do
    envelope = %Envelope{private: %Envelope.Private{request_pipeline: ["MockTransformerBad"]}}

    assert {:error, envelope, "Transformer did not return a valid response tuple"} =
             Pipeline.process(envelope, :request, envelope.private.request_pipeline)

    assert_pipeline_trail(envelope, [])
  end

  test "log error when response tuple is invalid" do
    envelope = %Envelope{private: %Envelope.Private{request_pipeline: ["MockTransformerBad"]}}

    assert capture_log(fn ->
             Pipeline.process(envelope, :request, envelope.private.request_pipeline)
           end) =~ "Transformer did not return a valid response tuple"
  end

  test "send event when response tuple is invalid" do
    envelope = %Envelope{private: %Envelope.Private{request_pipeline: ["MockTransformerBad"]}}

    assert_metric({[:error, :pipeline, :process, :unhandled], %{}, %{}}, fn ->
      Pipeline.process(envelope, :request, envelope.private.request_pipeline)
    end)
  end

  defp assert_pipeline_trail(envelope, expected_trail) do
    assert ^expected_trail = envelope.debug.request_pipeline_trail
  end
end
