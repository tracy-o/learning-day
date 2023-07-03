defmodule Belfrage.PreflightTransformers.DotComHomepagePlatformSelector do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    if String.ends_with?(request.host, "bbc.com") do
      {:ok, Envelope.add(envelope, :private, %{platform: "DotComHomepage"})}
    else
      {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
    end
  end
end
