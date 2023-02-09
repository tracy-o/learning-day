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
  def call(envelope) do
    {:ok, envelope, {:add, development_transformers(envelope)}}
  end

  def development_transformers(envelope) do
    Keyword.get(@request_type_to_transformer_mapping, development_request_type(envelope.request), [])
  end

  defp development_request_type(%{has_been_replayed?: true}), do: :replayed
  defp development_request_type(_), do: :no_match
end
