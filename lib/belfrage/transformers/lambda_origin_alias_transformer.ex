defmodule Belfrage.Transformers.LambdaOriginAliasTransformer do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: "www"}, private: private}) do
    struct = Struct.add(struct, :private, %{origin: "#{private.origin}:#{production_environment}"})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{request: request, private: private}) do
    struct = Struct.add(struct, :private, %{origin: preview_origin_override(struct)})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end

  defp production_environment(), do: Application.get_env(:belfrage, :production_environment)

  defp preview_origin_override(struct) do
    "#{origin(struct.private.loop_id)}:#{struct.request.subdomain}"
  end

  defp origin("ServiceWorker"), do: :preview_service_worker_lambda_function

  defp origin("Graphql"), do: :preview_graphql_lambda_function

  defp origin(_), do: :preview_pwa_lambda_function
end
