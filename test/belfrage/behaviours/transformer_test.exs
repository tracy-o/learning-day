defmodule Belfrage.Behaviours.TransformerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Behaviours.Transformer, as: Subject
  alias Belfrage.Envelope

  test "call request transformer behaviour" do
    stub_dial(:circuit_breaker, "false")

    envelope = %Envelope{private: %Envelope.Private{request_pipeline: ["CircuitBreaker"]}}

    assert {:ok, %Envelope{debug: %Belfrage.Envelope.Debug{request_pipeline_trail: ["CircuitBreaker"]}}} =
             Subject.call(envelope, :request, "CircuitBreaker")
  end

  test "call response transformer behaviour" do
    stub_dial(:etag, "false")

    envelope = %Envelope{
      private: %Envelope.Private{response_pipeline: ["Etag", "MvtMapper"]},
      debug: %Belfrage.Envelope.Debug{response_pipeline_trail: ["Etag"]}
    }

    assert {:ok, %Envelope{debug: %Belfrage.Envelope.Debug{response_pipeline_trail: ["MvtMapper", "Etag"]}}} =
             Subject.call(envelope, :response, "MvtMapper")
  end
end
