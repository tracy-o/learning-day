defmodule Belfrage.PreflightServices.AresData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  alias Belfrage.Helpers.QueryParams
  @behaviour PreflightService

  @impl PreflightService
  def request(%Envelope{request: %Envelope.Request{path: path, query_params: query_params}}) do
    %{
      method: :get,
      url:
        Application.get_env(:belfrage, :fabl_endpoint) <>
          "/module/ares-asset-identifier" <> QueryParams.encode(%{path: path}) <> QueryParams.encode(query_params),
      timeout: 500
    }
  end

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{"data" => %{"type" => asset_type}}), do: {:ok, asset_type}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
