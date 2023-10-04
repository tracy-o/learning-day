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
          "/module/ares-asset-identifier" <> QueryParams.encode(%{path: path}),
      timeout: 500,
      headers: maybe_put_test_header(query_params)
    }
  end

  defp maybe_put_test_header(%{"mode" => "testData"}) do
    %{"ctx-service-env" => "test"}
  end

  defp maybe_put_test_header(%{"mode" => "previewFABLWithTestData"}) do
    %{"ctx-service-env" => "test"}
  end

  defp maybe_put_test_header(_), do: %{}

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{"data" => %{"type" => asset_type}}), do: {:ok, asset_type}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
