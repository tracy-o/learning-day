defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService
  require Logger

  @dial Application.compile_env(:belfrage, :dial)

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @impl Transformer
  def call(envelope = %Envelope{}) do
    asset_response =
      case {valid_path?(envelope.request.path), @dial.state(:preflight_ares_data_fetch)} do
        {true, "on"} ->
          fetch_data(envelope)

        {true, "learning"} ->
          fetch_data(envelope)
          {:error, :ares_data_dial_learning_mode}

        {false, _} ->
          {:error, :invalid_path}

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

  defp valid_path?(path) do
    String.match?(path, ~r/\A\/news\/([a-zA-Z0-9-_\/+]+)\z/)
  end
end
