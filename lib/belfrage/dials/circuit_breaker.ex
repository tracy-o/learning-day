defmodule Belfrage.Dials.CircuitBreaker do
  @moduledoc false

  @behaviour Belfrage.Dial.Client

  @impl Belfrage.Dial.Client
  def transform("true"), do: true

  @impl Belfrage.Dial.Client
  def transform("false"), do: false
end
