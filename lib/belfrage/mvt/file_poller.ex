defmodule Belfrage.Mvt.FilePoller do
  @moduledoc """
  This process periodically fetches a JSON file containing headers used for MVT slots allocation.
  """

  use Belfrage.Poller, interval: Application.get_env(:belfrage, :poller_intervals)[:mvt_file]
  alias Belfrage.Mvt
  alias Belfrage.Clients
  require Logger

  @http_pool :MvtFilePoller

  @impl Belfrage.Poller
  def poll() do
    with {:ok, headers_map} <- Clients.Json.get(slots_file_location(), @http_pool, name: "mvt_slots"),
         {:ok, projects} <- Map.fetch(headers_map, "projects"),
         {:ok, normalised_projects} when normalised_projects != %{} <- normalise_projects(projects) do
      set_header_state(normalised_projects)
    end

    :ok
  end

  defp slots_file_location, do: Application.get_env(:belfrage, :mvt)[:slots_file_location]

  defp set_header_state(headers) do
    Mvt.Slots.set(headers)
  end

  # Attempts to normalise each project entry using normalise_slots/1.
  # If a slot entry in a project does not match the expected format,
  # a FunctionClauseError error will be thrown from the normalise_slots/1
  # function, rescued here, and a message highlighting the error will be logged.
  defp normalise_projects(projects) do
    try do
      normalised_projects =
        for {project, slots} <- projects, into: %{} do
          {project, normalise_slots(slots)}
        end

      {:ok, normalised_projects}
    rescue
      FunctionClauseError ->
        Logger.log(
          :error,
          "",
          %{
            msg: "Error normalising MVT slots - the actual format does not match the expected format."
          }
        )

        {:error, :invalid_slot_format}
    end
  end

  # Changes the format of projects slots so that the key-value pairs can be compared
  # to the MVT raw request headers. For example, the project_slots:
  #
  #     [%{"header" => "bbc-mvt-1", "key" => "box_colour_change"}]
  #
  # Will be normalised to:
  #
  #     %{"bbc-mvt-1", "box_colour_change"}
  #
  defp normalise_slots(slots) do
    Enum.into(slots, %{}, fn %{"header" => key, "key" => value} ->
      {key, value}
    end)
  end
end
