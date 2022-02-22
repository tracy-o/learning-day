defmodule Benchmark.LocationTopicMappings do
  @moduledoc """
  Performance benchmarking of `Belfrage.Transformers.LocalNewsTopicsRedirect.LocationTopicMappings`

  ### To run this experiment
  ```
  $ mix benchmark location_topic_mappings
  ```
  """

  alias Belfrage.Transformers.LocalNewsTopicsRedirect.LocationTopicMappings

  def run(_) do
    experiment()
  end

  def setup() do
    Enum.random(1..17_000)
  end

  def experiment(_iterations \\ 1000) do
    location_id = setup()

    Benchee.run(
      %{
        "LocationTopicMappings.get_topic_id/1" => fn -> LocationTopicMappings.get_topic_id(location_id) end
      },
      time: 10,
      memory_time: 2
    )
  end
end
