defmodule LearningDay.Systems.Marshall do
  @moduledoc """
  Documentation for Marshall system.
  """
  @behaviour ECSx.System

  alias LearningDay.Components.Envelope.Private.{Partition, Platform, Spec}

  @doc """
    Whenever spec, platform or partition is changed, RouteStateID is updated if it exists
    """
  @impl ECSx.System
  def run do
    for {entity, platform_name} <- Platform.get_all() do
      Platform.update(entity, platform_name <> " new name")
    end
  end
end
