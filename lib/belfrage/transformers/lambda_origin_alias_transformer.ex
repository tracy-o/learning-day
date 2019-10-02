defmodule Belfrage.Transformers.LambdaOriginAliasTransformer do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: "www"}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{production_environment()}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{}) do
    struct = Struct.add(struct, :private, %{origin: preview_origin_override(struct)})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end

  defp production_environment(), do: Application.get_env(:belfrage, :production_environment)

  defp preview_origin_override(struct = %Struct{request: %Struct.Request{subdomain: subdomain, playground?: true}}) do
    "#{struct.private.origin}:#{struct.request.subdomain}"
  end

  defp preview_origin_override(struct = %Struct{request: %Struct.Request{subdomain: subdomain}}) do
    "#{origin(struct.private.loop_id)}:#{struct.request.subdomain}"
  end

  defp origin(name) do
    Application.get_env(:belfrage, origin_pointer(name))
  end

  defp origin_pointer("ContainerData"), do: :preview_api_lambda_function

  defp origin_pointer(_), do: :preview_pwa_lambda_function
end
