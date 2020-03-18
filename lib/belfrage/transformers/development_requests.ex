defmodule Belfrage.Transformers.DevelopmentRequests do
  @moduledoc """
  Prepends transformers that are needed to satisfy the
  request a developer has made.
  """
  use Belfrage.Transformers.Transformer

  @request_type_to_transformer_mapping [
    replayed: ["ReplayedTraffic"]
  ]

  @impl true
  def call(rest, struct) do
    then(development_transformers(struct) ++ rest, struct)
  end

  def development_transformers(struct) do
    Keyword.get(@request_type_to_transformer_mapping, development_request_type(struct.request), [])
  end

  defp development_request_type(%{has_been_replayed?: true}), do: :replayed
  defp development_request_type(_), do: :no_match

end
