defmodule Belfrage.Mvt.FilePoller do
  @moduledoc """
  This process periodically fetches a JSON file containing headers used for MVT slots allocation.
  """

  use Belfrage.Poller, interval: Application.compile_env!(:belfrage, :poller_intervals)[:mvt_file]
  alias Belfrage.Mvt
  alias Belfrage.Clients
  require Logger

  @http_pool :MvtFilePoller

  @impl Belfrage.Poller
  def poll() do
    with {:ok, headers_map} <- Clients.Json.get(slots_file_location(), @http_pool, name: "mvt_slots"),
         {:ok, projects} <- Map.fetch(headers_map, "projects"),
         {:ok, processed} when processed != %{} <- process_projects(projects) do
      set_header_state(processed)
    end

    :ok
  end

  defp slots_file_location, do: Application.get_env(:belfrage, :mvt)[:slots_file_location]

  defp set_header_state(headers) do
    Mvt.Slots.set(headers)
  end

  # Changes the format of a projects slot so that the key-value pair can be compared
  # to a MVT raw request header. For example, the project_slot:
  #
  #     %{"header" => "bbc-mvt-1", "key" => "box_colour_change"}
  #
  # Will be normalised to:
  #
  #     {"bbc-mvt-1", "box_colour_change"}
  #
  defp normalise_slot(%{"header" => key, "key" => value}) do
    {key, value}
  end

  # Takes a map that contains a "validFrom" key value pair, and
  # a "header" key value pair.
  #
  # If "validFrom":
  #
  # * Is not a valid datetime string then false is returned
  #   and a log message is emitted that includes the "header" value
  #   and the invalid "validFrom" value.
  #
  # * Is a valid datetime in the future then false is returned.
  #
  # * Is a valid datetime that is not in the future then true is returned.
  defp valid?(%{"header" => key, "validFrom" => string}) do
    case DateTime.from_iso8601(string) do
      {:ok, datetime, _utc_offset} ->
        DateTime.compare(datetime, DateTime.utc_now()) in [:lt, :eq]

      _ ->
        Logger.log(
          :error,
          "",
          %{
            msg: "Datetime string: #{string} in slot: #{key} could not be parsed"
          }
        )

        false
    end
  end

  # Processes a map of projects.
  #
  # Each project key has a corresponding value that is an Enumerable collection of slots.
  #
  # The slots are processed using process_slots/1.
  #
  # If during processing a FunctionClauseError error is thrown, the error is caught and logged.
  defp process_projects(projects) do
    try do
      {:ok,
       for {project, slots} <- projects, into: %{} do
         {project, process_slots(slots)}
       end}
    rescue
      FunctionClauseError ->
        Logger.log(
          :error,
          "",
          %{
            msg:
              "Error processing MVT slot - the expected format: %{\"header\" => key, \"key\" => value, \"validFrom\" => string} does not match the actual format"
          }
        )

        {:error, :invalid_slot_format}
    end
  end

  # Processes Enumeration of slots.
  #
  # First we check if a slot is valid using valid?/1.
  #
  # If a slot is not valid, then we remove it slot from the final map.
  #
  # If a slot is valid, then we attempt to normalise it.
  defp process_slots(slots) do
    Enum.reduce(slots, %{}, fn slot, acc ->
      if valid?(slot) do
        {k, v} = normalise_slot(slot)
        Map.put(acc, k, v)
      else
        acc
      end
    end)
  end
end
