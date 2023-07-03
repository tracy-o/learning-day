defmodule Belfrage.PreflightTransformers.HomepagePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon

  @route_platform "DotComHomepage"

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    if String.ends_with?(request.host, "bbc.com") do
      BBCXPlatformSelectorCommon.add_platform_to_envelope(envelope, @route_platform)
    else
      {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
    end
  end
end
