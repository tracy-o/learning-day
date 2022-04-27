defmodule Belfrage.Mvt.FilePoller do
  @moduledoc """
  This process periodically fetches a JSON file containing headers used for MVT slots allocation.
  """

  use GenServer
  alias Belfrage.Mvt

  @client Application.get_env(:belfrage, :json_client)
  @interval Application.get_env(:belfrage, :mvt)[:slots_header_file_polling_interval]
  @http_pool :MvtFilePoller

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, Keyword.get(opts, :interval, @interval), name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(interval) do
    schedule_polling(interval)
    {:ok, interval}
  end

  defp schedule_polling(interval) do
    Process.send_after(self(), :poll, interval)
  end

  @impl true
  def handle_info(:poll, interval) do
    schedule_polling(interval)

    with {:ok, headers_map} <- @client.get(slots_file_location(), @http_pool, name: "mvt_slots") do
      set_header_state(headers_map["projects"])
    end

    {:noreply, interval}
  end

  defp slots_file_location, do: Application.get_env(:belfrage, :mvt)[:slots_file_location]

  defp set_header_state(headers) do
    Mvt.Headers.set(headers)
  end
end
