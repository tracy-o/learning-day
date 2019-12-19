defmodule Belfrage.Transformers.PreviewLambda do
  use Belfrage.Transformers.Transformer

  @preview_lambda_origin Application.get_env(:belfrage, :preview_pwa_lambda_function)

  @impl true
  def call(rest, struct) do
    struct = Struct.add(struct, :private, %{origin: @preview_lambda_origin})

    then(rest, struct)
  end
end
