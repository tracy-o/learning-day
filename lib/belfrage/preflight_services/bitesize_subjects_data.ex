defmodule Belfrage.PreflightServices.BitesizeSubjectsData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  alias Belfrage.Helpers.QueryParams
  @behaviour PreflightService

  @impl PreflightService
  def request(%Envelope{request: %Envelope.Request{path_params: %{"id" => id}}}) do
    %{
      method: :get,
      url:
        Application.get_env(:belfrage, :fabl_endpoint) <>
          "/module/education-metadata" <>
          QueryParams.encode(%{service: "bitesize", id: id, type: "subject", preflight: "true"}),
      timeout: 1_000
    }
  end

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{"data" => %{"phase" => %{"label" => label}}}), do: {:ok, label}
  def handle_response(%{"data" => %{"phase" => %{}}}), do: {:ok, ""}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
