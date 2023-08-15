defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Behaviours.PreflightService
  alias BelfrageWeb.Validators
  require Logger

  @dial Application.compile_env(:belfrage, :dial)

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @impl Transformer
  def call(envelope = %Envelope{}) do
    asset_response =
      case {valid_asset_id?(envelope.request.path_params["id"]), @dial.state(:preflight_ares_data_fetch)} do
        {true, "on"} ->
          fetch_data(envelope)

        {true, "learning"} ->
          {_state, envelope, _metadata} = fetch_data(envelope)
          {:error, envelope, :ares_data_dial_learning_mode}

        {false, _} ->
          {:error, envelope, :invalid_path}

        _ ->
          {:error, envelope, :ares_data_dial_off}
      end

    envelope =
      case asset_response do
        {:ok, envelope, asset_type} ->
          if asset_type in @webcore_asset_types do
            Envelope.add(envelope, :private, %{platform: "Webcore"})
          else
            Envelope.add(envelope, :private, %{platform: "MozartNews"})
          end

        {:error, envelope, _metadata} ->
          if stack_id() == "joan" do
            Envelope.add(envelope, :private, %{platform: "MozartNews"})
          else
            Envelope.add(envelope, :private, %{platform: "Webcore"})
          end
      end

    {:ok, envelope}
  end

  defp fetch_data(envelope) do
    PreflightService.call(envelope, "AresData")
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
