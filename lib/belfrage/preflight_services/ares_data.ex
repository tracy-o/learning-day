defmodule Belfrage.PreflightServices.AresData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  alias Belfrage.Helpers.QueryParams
  @behaviour PreflightService

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
  def handle_response(%{"data" => %{"assetType" => asset_type}}), do: {:ok, asset_type}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
