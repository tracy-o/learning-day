defmodule Belfrage.Dials.DialStub do
  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("true"), do: true

  @impl Belfrage.Dial
  def transform("false"), do: false

  @impl Belfrage.Dial
  def on_change(_transformed_val), do: :ok
end
