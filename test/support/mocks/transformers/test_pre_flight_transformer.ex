defmodule Belfrage.PreFlightTransformers.TestPreFlightTransformer do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @impl Transformer
  def call(envelope = %Envelope{request: request})
      when request.path == "/platform-selection-with-mozart-news-platform" do
    {:ok, Envelope.add(envelope, :private, %{platform: "MozartNews"})}
  end

  def call(envelope) do
    {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
  end
end
