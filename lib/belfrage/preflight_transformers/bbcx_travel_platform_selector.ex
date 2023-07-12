defmodule Belfrage.PreflightTransformers.BBCXTravelPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon

  @route_platform "DotComTravel"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    BBCXPlatformSelectorCommon.add_platform_to_envelope(envelope, @route_platform)
  end
end