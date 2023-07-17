defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService
  require Logger

  @dial Application.compile_env(:belfrage, :dial)

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @impl Transformer
  def call(envelope = %Envelope{}) do
    platform =
      case maybe_fetch_data(envelope) do
        {:ok, asset_type} when asset_type in @webcore_asset_types ->
          "Webcore"

        _ ->
          "MozartNews"
      end

    if envelope.private.production_environment == "live" do
      {:ok, Envelope.add(envelope, :private, %{platform: "MozartNews"})}
    else
      {:ok, Envelope.add(envelope, :private, %{platform: platform})}
    end
  end

  defp maybe_fetch_data(envelope) do
    if @dial.state(:preflight_ares_data_fetch) == "on" do
      PreflightService.call(envelope, "AresData")
    else
      {:error, :ares_data_dial_off}
    end
  end
end
