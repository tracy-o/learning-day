defmodule Belfrage.Transformers.PreviewLambda do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    struct = Struct.add(struct, :private, %{origin: preview_lambda_origin})

    then(rest, struct)
  end

  defp preview_lambda_origin do
    Application.get_env(:belfrage, :preview_pwa_lambda_function)
  end
end
