defmodule Belfrage.RequestTransformers.MockTransformer do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    send(self(), :mock_transformer_called)
    {:ok, struct}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerAdd do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    send(self(), :mock_transformer_add_called)
    {:ok, struct, {:add, [MockTransformer]}}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerReplace do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    send(self(), :mock_transformer_replace_called)
    {:ok, struct, {:replace, [MockTransformer]}}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerStop do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    send(self(), :mock_transformer_stop_called)
    {:stop, struct}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    send(self(), :mock_transformer_redirect_called)
    {:stop, struct}
  end
end
