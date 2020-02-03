defmodule Belfrage.Transformers.LambdaOriginAlias do
  @moduledoc """
  Appends the alias for a lambda function.
  """
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: "www"}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{private.production_environment}"})
    then(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: subdomain}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{lambda_alias(subdomain, private.production_environment)}"})

    then(rest, struct)
  end

  defp lambda_alias(_, "live"), do: "live"

  defp lambda_alias(subdomain, _), do: subdomain

end