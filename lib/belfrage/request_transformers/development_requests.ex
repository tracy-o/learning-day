defmodule Belfrage.RequestTransformers.DevelopmentRequests do
  @moduledoc """
  Prepends transformers that are needed to satisfy the
  request a developer has made.
  """
  use Belfrage.Behaviours.Transformer

  @request_type_to_transformer_mapping [
    replayed: ["ReplayedTraffic"]
  ]

  @impl Transformer
  def call(struct) do
    {:ok, struct, {:add, development_transformers(struct)}}
  end

  def development_transformers(struct) do
    Keyword.get(@request_type_to_transformer_mapping, development_request_type(struct.request), [])
  end

  defp development_request_type(%{has_been_replayed?: true}), do: :replayed
  defp development_request_type(_), do: :no_match
end
