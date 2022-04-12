defmodule Belfrage.Mvt.Headers do
  @moduledoc """
  This process helps Belfrage keep in Sync with the Mvt Slot Supervisor and exposes a list of the currently allowed headers.
  This list of headers are polled periodically via the `Belfrage.Mvt.Filepoller` and this module updates the state of them, with functions to callback the list when required.
  """

  use Agent

  def start_link(opts \\ []) do
    Agent.start_link(fn -> [] end, name: Keyword.get(opts, :name, __MODULE__))
  end

  @doc """
   This function returns a Map of the available headers that have been fetched from the Mvt Slots Supervisor.
   We attempt to update this Map every minute.
  """
  def get(agent \\ __MODULE__) do
    Agent.get(agent, & &1)
  end

  def set(agent \\ __MODULE__, header_list) do
    Agent.update(agent, fn state -> header_list end)
  end
end
