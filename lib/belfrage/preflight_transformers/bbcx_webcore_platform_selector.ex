defmodule Belfrage.PreflightTransformers.BBCXWebcorePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Brands, Envelope}

  @route_platform "Webcore"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    BBCXPlatformSelectorCommon.add_platform_to_envelope(envelope, @route_platform)
  end
end
