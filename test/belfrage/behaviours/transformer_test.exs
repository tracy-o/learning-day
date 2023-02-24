defmodule Belfrage.Behaviours.TransformerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Behaviours.Transformer, as: Subject
  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Private, Debug}

  test "call request transformer behaviour" do
    stub_dial(:circuit_breaker, "false")

    envelope = %Envelope{private: %Private{request_pipeline: ["CircuitBreaker"]}}

    assert {:ok, %Envelope{debug: %Debug{request_pipeline_trail: ["CircuitBreaker"]}}} =
             Subject.call(envelope, :request, "CircuitBreaker")
  end

  test "call response transformer behaviour" do
    stub_dial(:etag, "false")

    envelope = %Envelope{
      private: %Private{response_pipeline: ["Etag", "MvtMapper"]},
      debug: %Debug{response_pipeline_trail: ["Etag"]}
    }

    assert {:ok, %Envelope{debug: %Debug{response_pipeline_trail: ["MvtMapper", "Etag"]}}} =
             Subject.call(envelope, :response, "MvtMapper")
  end

  test "call pre-flight transformer behaviour" do
    envelope = %Envelope{
      debug: %Debug{response_pipeline_trail: ["TestPreFlightTransformer"]}
    }

    assert {:ok,
            %Envelope{
              private: %Private{platform: "Webcore"},
              debug: %Debug{pre_flight_pipeline_trail: ["TestPreFlightTransformer"]}
            }} = Subject.call(envelope, :pre_flight, "TestPreFlightTransformer")
  end
end
