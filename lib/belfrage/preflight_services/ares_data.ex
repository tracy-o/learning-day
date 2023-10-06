defmodule Belfrage.PreflightServices.AresData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  alias Belfrage.Helpers.QueryParams
  @behaviour PreflightService

  @impl PreflightService
  def request(%Envelope{
        request: %Envelope.Request{path: path, query_params: query_params},
        private: %Envelope.Private{production_environment: env}
      }) do
    %{
      method: :get,
      url:
        Application.get_env(:belfrage, :fabl_endpoint) <>
          "/module/ares-asset-identifier" <> QueryParams.encode(%{path: path}),
      timeout: 500,
      headers: maybe_put_test_header(env, query_params)
    }
  end

  defp maybe_put_test_header("test", query_params), do: put_test_header(query_params)
  defp maybe_put_test_header(_, _query_params), do: %{}

  defp put_test_header(%{"mode" => "testData"}), do: %{"ctx-service-env" => "test"}
  defp put_test_header(%{"mode" => "previewFABLWithTestData"}), do: %{"ctx-service-env" => "test"}
  defp put_test_header(_), do: %{}

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{"data" => %{"type" => asset_type}}), do: {:ok, asset_type}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
