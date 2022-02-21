defmodule Belfrage.Transformers.TransformerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.Transformer, as: Subject
  alias Belfrage.Struct

  test "when there are transformers in the list it will call the next one, seen via the reverse ordering in the debug pipeline trail" do
    stub_dial(:circuit_breaker, "false")

    struct = %Struct{private: %Struct.Private{pipeline: ["HTTPredirect", "CircuitBreaker"]}}

    assert {:ok, %Struct{debug: %Belfrage.Struct.Debug{pipeline_trail: ["CircuitBreaker", "HTTPredirect"]}}} =
             Subject.then_do(struct.private.pipeline, struct)
  end

  test "when there are no more transformers in the list it returns {:ok, struct}" do
    struct = %Struct{private: %Struct.Private{pipeline: []}}
    assert {:ok, _struct} = Subject.then_do([], struct)
  end
end
