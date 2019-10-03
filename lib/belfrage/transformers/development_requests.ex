defmodule Belfrage.Transformers.DevelopmentRequests do
  @moduledoc """
  Prepends transformers that are needed to satisfy the
  request a developer has made.
  """
  use Belfrage.Transformers.Transformer

  @request_type_to_transformer_mapping [
    playground: ["PlaygroundLambda"],
    preview: ["PreviewLambda"],
    replayed: ["ReplayedTraffic"]
  ]

  @impl true
  def call(rest, struct) do
    @preliminary_transformers 
    then(development_transformers(struct) ++ rest, struct)
  end

  def development_transformers(struct) do
    Keyword.get(@request_type_to_transformer_mapping, development_request_type(struct), [])
  end

  def development_request_type(struct) do
    case struct do
      %Struct{request: %Struct.Request{playground?: true, has_been_replayed?: nil}} -> :playground
      %Struct{request: %Struct.Request{has_been_replayed?: true}} -> :replayed
      %Struct{request: %Struct.Request{subdomain: subdomain}} when subdomain != "www" -> :preview
      _ -> :no_match
    end
  end
end
