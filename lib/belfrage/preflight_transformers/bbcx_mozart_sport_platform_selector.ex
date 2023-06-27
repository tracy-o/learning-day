defmodule Belfrage.PreflightTransformers.BBCXMozartSportPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope
  alias Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon

  @route_platform "MozartSport"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    BBCXPlatformSelectorCommon.add_platform_to_envelope(envelope, @route_platform)
  end
end
