defmodule Belfrage.PreflightServices.BitesizeArticlesData do
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
          QueryParams.encode(%{service: "bitesize", id: id, type: "article", preflight: "true"}),
      timeout: 1_000
    }
  end

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{
        "data" => %{
          "topicOfStudy" => %{"id" => topic_of_study_id},
          "phase" => %{"label" => phase_label}
        }
      }),
      do: {:ok, %{phase: phase_label, topic_of_study: topic_of_study_id}}

  def handle_response(%{"data" => %{"phase" => map}}) when map == %{}, do: {:ok, %{phase: map}}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
