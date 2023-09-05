defmodule Belfrage.Authentication.BBCID do
  @moduledoc """
  This process maintains the status of BBC ID services: whether they are
  working as expected or are unavailable or degraded. It only maintains the
  status, which is obtained from the BBC ID API separately.
  """

  use Agent

  def start_link(opts \\ []) do
    state = %{
      id_availability: Keyword.get(opts, :available, true),
      foryou_flagpole: false,
      foryou_access_chance: 0,
      foryou_allowlist: []
    }

    Agent.start_link(fn -> state end, name: Keyword.get(opts, :name, __MODULE__))
  end

  @spec available?() :: boolean()
  def available?(agent \\ __MODULE__), do: get_opts(agent)[:id_availability]

  @spec get_opts() :: map()
  def get_opts(agent \\ __MODULE__) do
    Agent.get(agent, & &1)
  end

  @spec set_opts(map()) :: :ok
  def set_opts(agent \\ __MODULE__, opts) when is_map(opts) do
    Agent.update(agent, fn _state -> opts end)
  end
end
