defmodule Belfrage.Services.Webcore.Credentials do
  @moduledoc """
  This module maintains the credentials for calling the Webcore lambda
  function.
  """

  use Agent

  alias Belfrage.AWS

  def start_link(opts \\ []) do
    Agent.start_link(fn -> %AWS.Credentials{} end, name: Keyword.get(opts, :name, __MODULE__))
  end

  def get(agent \\ __MODULE__) do
    Agent.get(agent, & &1)
  end

  def update(agent \\ __MODULE__, credentials = %AWS.Credentials{}) do
    Agent.update(agent, fn _state -> credentials end)
  end
end
