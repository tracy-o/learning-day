defmodule Belfrage.Services.Webcore.Credentials do
  @moduledoc """
  This module maintains the credentials for calling the Webcore lambda
  function. It gets them from the configured credentials source on startup.
  """

  use Agent

  alias Belfrage.AWS

  @source Application.get_env(:belfrage, :webcore_credentials_source)

  def start_link(opts \\ []) do
    {:ok, credentials} = @source.get()
    Agent.start_link(fn -> credentials end, name: Keyword.get(opts, :name, __MODULE__))
  end

  def get(agent \\ __MODULE__) do
    Agent.get(agent, & &1)
  end

  def update(agent \\ __MODULE__, credentials = %AWS.Credentials{}) do
    Agent.update(agent, fn _state -> credentials end)
  end
end
