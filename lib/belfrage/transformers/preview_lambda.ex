defmodule Belfrage.Transformers.PreviewLambda do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    struct = Struct.add(struct, :private, %{origin: preview_origin_override(struct.private.loop_id)})

    then(rest, struct)
  end

  defp preview_origin_override("ContainerData") do
    Application.get_env(:belfrage, :preview_pwa_lambda_function)
  end

  defp preview_origin_override(_) do
    Application.get_env(:belfrage, :preview_pwa_lambda_function)
  end
end
