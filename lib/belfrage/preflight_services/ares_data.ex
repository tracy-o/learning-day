defmodule Belfrage.PreflightServices.AresData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  alias Belfrage.Helpers.QueryParams
  @behaviour PreflightService

  @impl PreflightService
  def request(%Envelope{request: %Envelope.Request{path: path, host: host, query_params: query_params}}) do
    %{
      method: :get,
      url:
        Application.get_env(:belfrage, :fabl_endpoint) <>
          "/module/ares-asset-identifier" <> QueryParams.encode(%{path: path}),
      timeout: 500,
      headers: maybe_put_test_header(host, query_params)
    }
  end

  defp maybe_put_test_header(nil, _query_params), do: %{}

  defp maybe_put_test_header(host, query_params) do
    if String.contains?(host, "test") do
      put_test_header(query_params)
    else
      %{}
    end
  end

  defp put_test_header(%{"mode" => "testData"}) do
    %{"ctx-service-env" => "test"}
  end

  defp put_test_header(%{"mode" => "previewFABLWithTestData"}) do
    %{"ctx-service-env" => "test"}
  end

  defp put_test_header(_), do: %{}

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{"data" => %{"type" => asset_type}}), do: {:ok, asset_type}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
