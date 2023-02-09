defmodule Belfrage.RequestTransformers.MockTransformer do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    send(self(), :mock_transformer_called)
    {:ok, envelope}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerAdd do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    send(self(), :mock_transformer_add_called)
    {:ok, envelope, {:add, [MockTransformer]}}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerReplace do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    send(self(), :mock_transformer_replace_called)
    {:ok, envelope, {:replace, [MockTransformer]}}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerStop do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    send(self(), :mock_transformer_stop_called)
    {:stop, envelope}
  end
end

defmodule Belfrage.RequestTransformers.MockTransformerRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    send(self(), :mock_transformer_redirect_called)
    {:stop, envelope}
  end
end
