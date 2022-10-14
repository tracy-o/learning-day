defmodule Belfrage.RequestTransformers.MockTransformer do
  use Belfrage.Transformer

  @impl true
  def call(rest, struct) do
    send(self(), :mock_transformer_called)
    then_do(rest, struct)
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerStop do
  use Belfrage.Transformer

  @impl true
  def call(_rest, struct) do
    send(self(), :mock_transformer_stop_called)
    {:stop_pipeline, struct}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerRedirect do
  use Belfrage.Transformer

  @impl true
  def call(_rest, struct) do
    send(self(), :mock_transformer_redirect_called)
    {:redirect, struct}
  end
end
