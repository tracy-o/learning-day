defmodule Belfrage.PreflightTransformers.BBCXTopicsWebcorePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon
  alias BelfrageWeb.Validators
  alias Belfrage.{Envelope}

  @route_platform "Webcore"

  @impl Transformer
  def call(envelope) do
    if Validators.is_tipo_id?(envelope.request.path_params["id"]) and
         !Map.has_key?(envelope.request.path_params, "slug") do
      BBCXPlatformSelectorCommon.add_platform_to_envelope(envelope, @route_platform)
    else
      {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
    end
  end
end
