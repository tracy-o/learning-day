defmodule Belfrage.Transformers.LambdaOriginAliasTransformer do
  use Belfrage.Transformers.Transformer

  @production_environment Application.get_env(:belfrage, :production_environment)

  @impl true
  def call(rest, struct = %Struct{private: %Struct.Private{origin: origin, subdomain: "www"}}) do
    struct = Struct.add(struct, :private, %{origin: "#{origin}:#{@production_environment}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{private: %Struct.Private{origin: origin, subdomain: subdomain}}) do
    struct = Struct.add(struct, :private, %{origin: "#{origin}:#{subdomain}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end
end
