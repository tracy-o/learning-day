defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService
  require Logger

  @dial Application.compile_env(:belfrage, :dial)

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @impl Transformer
  def call(envelope = %Envelope{}) do
    asset_response =
      case @dial.state(:preflight_ares_data_fetch) do
        "on" ->
          fetch_data(envelope)

        "learning" ->
          fetch_data(envelope)
          {:error, :ares_data_dial_learning_mode}

        _ ->
          {:error, :ares_data_dial_off}
      end

    platform =
      case asset_response do
        {:ok, asset_type} ->
          if asset_type in @webcore_asset_types do
            "Webcore"
          else
            "MozartNews"
          end

        _ ->
          if stack_id() == "joan" do
            "MozartNews"
          else
            "Webcore"
          end
      end

    {:ok, Envelope.add(envelope, :private, %{platform: platform})}
  end

  defp fetch_data(envelope) do
    PreflightService.call(envelope, "AresData")
  end

  defp stack_id() do
    Application.get_env(:belfrage, :stack_id)
  end
end
