defmodule Belfrage.Dial.ClientStub do
  @behaviour Belfrage.Dial.Client

  @impl Belfrage.Dial.Client
  def transform("true"), do: true

  @impl Belfrage.Dial.Client
  def transform("false"), do: false

  @impl Belfrage.Dial.Client
  def on_change(_transformed_val), do: :ok
end
