defmodule Belfrage.PreflightServices.AresData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  alias Belfrage.Helpers.QueryParams

  use Belfrage.PreflightServices, cache_prefix: "AresData"

  @impl PreflightService
  def request(%Envelope{request: %Envelope.Request{path: path}}) do
    %{
      method: :get,
      url:
        Application.get_env(:belfrage, :fabl_endpoint) <>
          "/preview/module/spike-ares-asset-identifier" <> QueryParams.encode(%{path: path}),
      timeout: 1_000
    }
  end

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def callback_success(response) do
    case response do
      %{"data" => %{"assetType" => asset_type}} ->
        {:ok, asset_type}

      _ ->
        {:error, :preflight_data_error}
    end
  end
end
