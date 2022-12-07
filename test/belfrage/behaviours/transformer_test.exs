defmodule Belfrage.TransformerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Behaviours.Transformer, as: Subject
  alias Belfrage.Struct

  test "when there are transformers in the list it will call the next one, seen via the reverse ordering in the debug pipeline trail" do
    stub_dial(:circuit_breaker, "false")

    struct = %Struct{private: %Struct.Private{request_pipeline: ["CircuitBreaker"]}}

    assert {:ok, %Struct{debug: %Belfrage.Struct.Debug{request_pipeline_trail: ["CircuitBreaker"]}}} =
             Subject.call(struct, :request, "CircuitBreaker")
  end

#  test "when there are no more transformers in the list it returns {:ok, struct}" do
#    struct = %Struct{private: %Struct.Private{request_pipeline: []}}
#    assert {:ok, _struct} = Subject.call(struct, :request, [])
#  end
end
