defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias BelfrageWeb.Validators
  alias Belfrage.{Behaviours.PreflightService, Envelope, Envelope.Private}
  require Logger

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]
  @service "AresData"

  @impl Transformer
  def call(envelope = %Envelope{}) do
    asset_response =
      if valid_asset_id?(envelope.request.path_params["id"]) do
        PreflightService.call(envelope, @service)
      else
        {:error, envelope, :invalid_path}
      end

    envelope =
      case asset_response do
        {:ok, envelope = %Envelope{private: %Private{preflight_metadata: metadata}}} ->
          asset_type = Map.get(metadata, @service)

          if asset_type in @webcore_asset_types do
            Envelope.add(envelope, :private, %{platform: "Webcore"})
          else
            Envelope.add(envelope, :private, %{platform: "MozartNews"})
          end

        {:error, envelope, _reason} ->
          if stack_id() == "joan" do
            Envelope.add(envelope, :private, %{platform: "MozartNews"})
          else
            Envelope.add(envelope, :private, %{platform: "Webcore"})
          end
      end

    {:ok, envelope}
  end

  defp stack_id() do
    Application.get_env(:belfrage, :stack_id)
  end

  defp valid_asset_id?(asset_id) do
    if asset_id do
      Validators.is_cps_id?(asset_id)
    end
  end
end
