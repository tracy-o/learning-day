defmodule Benchmark.Base64Decode do
  @moduledoc """
  Performance benchmarking of `Base.decode64/1`
  and other decoding functions to compare

  ### To run this experiment
  ```
  	$ mix benchmark base64_decode
  ```

  ### Expected outcomes
  - performance implication of building (decoding) response with base64 content
  """

  import Fixtures.Lambda

  def run(_) do
    experiment()
  end

  def setup() do
    gzip_base64_lambda_resp(100)
  end

  def experiment(_iterations \\ 1000) do
    %{"body" => lambda_response_body} = setup()

    Benchee.run(
      %{
        "Base.decode64/1" => fn -> Base.decode64(lambda_response_body) end,
        ":base64.decode/1" => fn -> :base64.decode(lambda_response_body) end
      },
      time: 10,
      memory_time: 2
    )
  end
end
