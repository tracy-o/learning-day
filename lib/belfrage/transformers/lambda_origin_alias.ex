defmodule Belfrage.Transformers.LambdaOriginAlias do
  @moduledoc """
  Appends the alias for a lambda function.
  """
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: "www", production_environment: "test"}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{struct.request.production_environment}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: subdomain}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{lambda_alias(subdomain, struct.request.production_environment)}"})

    then(rest, struct)
  end

  defp lambda_alias(subdomain, production_environment) do
    case production_environment do
      "live" -> "live"
      _ -> subdomain
    end
  end
end
