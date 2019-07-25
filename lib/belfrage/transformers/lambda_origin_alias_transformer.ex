defmodule Belfrage.Transformers.LambdaOriginAliasTransformer do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: "www"}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{production_environment}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{request: request, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{request.subdomain}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end

  defp production_environment(), do: Application.get_env(:belfrage, :production_environment)
end
