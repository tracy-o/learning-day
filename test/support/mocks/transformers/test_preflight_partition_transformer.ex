defmodule Belfrage.PreflightTransformers.TestPreflightPartitionTransformer do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @impl Transformer
  def call(envelope = %Envelope{}) do
    {:ok, Envelope.add(envelope, :private, %{partition: "Partition1"})}
  end
end
