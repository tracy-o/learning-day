defmodule Benchmark.MapMerge do
  @moduledoc """
  Performance benchmarking of `Map.merge/2`

  ### To run this experiment
  ```
  	$ mix benchmark map_merge
  ```

  ### Expected outcomes
  - performance implication of merging maps
  """

  import Fixtures.Lambda

  def run(_) do
    experiment()
  end

  def setup() do
    gzip_base64_lambda_resp(100)
  end

  def experiment(_iterations \\ 1000) do
    lambda_response = %{"body" => lambda_response_body} = setup()

    Benchee.run(
      %{
        "Map.merge/1" => fn -> Map.merge(lambda_response, new_items(lambda_response)) end,
        "%{|}" => fn -> %{lambda_response | "body" => lambda_response_body, "isBase64Encoded" => false} end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp new_items(%{"body" => body, "isBase64Encoded" => _isBase64Encoded}) do
    %{
      "body" => body,
      "isBase64Encoded" => false
    }
  end
end
