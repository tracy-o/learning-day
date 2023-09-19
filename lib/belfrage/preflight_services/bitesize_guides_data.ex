defmodule Belfrage.PreflightServices.BitesizeGuidesData do
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
          QueryParams.encode(%{service: "bitesize", id: id, type: "guide", preflight: "true"}),
      timeout: 1_000
    }
  end

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path_params: %{"id" => id}}}) do
    id
  end

  @impl PreflightService
  def handle_response(%{
        "data" => %{
          "examSpecification" => %{"id" => exam_specification_id},
          "level" => %{"id" => level_id}
        }
      }),
      do: {:ok, %{exam_specification: exam_specification_id, level: level_id}}

  def handle_response(%{
        "data" => %{
          "examSpecification" => map,
          "level" => map
        }
      })
      when map == %{},
      do: {:ok, %{exam_specification: "", level: ""}}

  def handle_response(%{
        "data" => %{
          "examSpecification" => map,
          "level" => %{"id" => level_id}
        }
      })
      when map == %{},
      do: {:ok, %{exam_specification: "", level: level_id}}

  def handle_response(_response), do: {:error, :preflight_data_error}
end
