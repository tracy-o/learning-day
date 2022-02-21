defmodule Belfrage.Transformers.MockTransformer do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    send(self(), :mock_transformer_called)
    then_do(rest, struct)
  end
end

defmodule Belfrage.Transformers.MockTransformerStop do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct) do
    send(self(), :mock_transformer_stop_called)
    {:stop_pipeline, struct}
  end
end

defmodule Belfrage.Transformers.MockTransformerRedirect do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct) do
    send(self(), :mock_transformer_redirect_called)
    {:redirect, struct}
  end
end
