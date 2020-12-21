defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.CircuitBreaker

  test "transform/1 converts string representation of 'true' to boolean" do
    assert CircuitBreaker.transform("true") === true
  end

  test "transform/1 converts string representation of 'false' to boolean" do
    assert CircuitBreaker.transform("false") === false
  end
end
