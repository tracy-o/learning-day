defmodule Belfrage.Behaviours.TransformerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Behaviours.Transformer, as: Subject
  alias Belfrage.Struct

  test "call request transformer behaviour" do
    stub_dial(:circuit_breaker, "false")

    struct = %Struct{private: %Struct.Private{request_pipeline: ["CircuitBreaker"]}}

    assert {:ok, %Struct{debug: %Belfrage.Struct.Debug{request_pipeline_trail: ["CircuitBreaker"]}}} =
             Subject.call(struct, :request, "CircuitBreaker")
  end

  test "call response transformer behaviour" do
    stub_dial(:etag, "false")

    struct = %Struct{
      private: %Struct.Private{response_pipeline: ["Etag", "MvtMapper"]},
      debug: %Belfrage.Struct.Debug{response_pipeline_trail: ["Etag"]}
    }

    assert {:ok, %Struct{debug: %Belfrage.Struct.Debug{response_pipeline_trail: ["MvtMapper", "Etag"]}}} =
             Subject.call(struct, :response, "MvtMapper")
  end
end
