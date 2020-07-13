defmodule Belfrage.Dials.CircuitBreaker do
  @moduledoc false

  @behaviour Belfrage.Dial

  use Belfrage.Dial, dial: "circuit_breaker"

  @impl Belfrage.Dial
  def transform("true"), do: true

  @impl Belfrage.Dial
  def transform("false"), do: false
end
