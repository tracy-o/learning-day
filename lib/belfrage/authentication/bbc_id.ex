defmodule Belfrage.Authentication.BBCID do
  @moduledoc """
  This process maintains the status of BBC ID services: whether they are
  working as expected or are unavailable or degraded. It only maintains the
  status, which is obtained from the BBC ID API separately.
  """

  use Agent

  def start_link(opts \\ []) do
    Agent.start_link(fn -> Keyword.get(opts, :available, true) end, name: Keyword.get(opts, :name, __MODULE__))
  end

  @doc """
  Returns `true` of `false` depending on whether the BBC ID services are
  available.
  """
  def available?(agent \\ __MODULE__) do
    Agent.get(agent, & &1)
  end

  def set_availability(agent \\ __MODULE__, available) when is_boolean(available) do
    Agent.update(agent, fn _state -> available end)
  end
end
