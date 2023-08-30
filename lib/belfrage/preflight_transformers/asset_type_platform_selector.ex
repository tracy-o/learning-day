defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias BelfrageWeb.Validators
  alias Belfrage.{Behaviours.PreflightService, Envelope}
  require Logger

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]
  @service "AresData"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    if valid_asset_id?(envelope.request.path_params["id"]) do
      case PreflightService.call(envelope, @service) do
        {:ok, envelope} -> {:ok, add_platform(envelope, get_platform(envelope))}
        {:error, envelope, :preflight_data_not_found} -> {:ok, add_platform(envelope, "MozartNews")}
        {:error, envelope, :preflight_data_error} -> {:error, envelope, 500}
      end
    else
      {:ok, add_platform(envelope, "MozartNews")}
    end
  end

  defp get_platform(envelope) do
    asset_type = Map.get(envelope.private.preflight_metadata, @service)

    if asset_type in @webcore_asset_types do
      "Webcore"
    else
      "MozartNews"
    end
  end

  defp valid_asset_id?(asset_id) do
    if asset_id do
      Validators.is_cps_id?(asset_id)
    end
  end

  defp add_platform(envelope, platform) do
    Envelope.add(envelope, :private, %{platform: platform})
  end
end
