defmodule Belfrage.PreflightTransformers.BBCXMozartNewsPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope
  alias Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon

  @route_platform "MozartNews"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    BBCXPlatformSelectorCommon.add_platform_to_envelope(envelope, @route_platform)
  end
end
