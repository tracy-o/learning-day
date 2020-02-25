defmodule Benchmark.WebcoreResponseBuild do
  @moduledoc """
  Performance benchmarking of `Belfrage.Services.Webcore.Response.build/1`
  with 4 different types of Lambda response: text, gzip (text), base64, gzip (base64).

  ### To run this experiment
  ```
  	$ mix benchmark webcore_response_build # with default 1kb random text content

  	$ mix benchmark webcore_response_build 1 100 # with 100kb payload

  	$ mix benchmark webcore_response_build 2 100 # repeat experiments twice (n times) with increments of 100kb payload
  ```

  ### Expected outcomes
  - performance implication of building (decoding) response with base64 content from Webcore Lambda
  """

  import Fixtures.Lambda
  alias Belfrage.Services.Webcore.Response

  # TODO: create a behaviour via template method design pattern
  def run([iteration]), do: experiment(iteration |> String.to_integer())
  def run([iteration, step_size]), do: experiment(iteration |> String.to_integer(), step_size |> String.to_integer())

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    experiment()
  end

  # TODO: cf. the use of Benchee `before_scenario` hook
  def setup(iteration \\ 1, step_size_kb \\ 1) do
    for i <- 1..iteration, into: %{} do
      size_kb = i * step_size_kb

      {
        size_kb,
        {
          lambda_resp(size_kb),
          gzip_lambda_resp(size_kb),
          base64_lambda_resp(size_kb),
          gzip_base64_lambda_resp(size_kb)
        }
      }
    end
  end

  # TODO: @impl true, a behaviour callback
  def experiment(iteration \\ 1, step_size_kb \\ 1) do
    setup(iteration, step_size_kb)
    |> Enum.map(fn {size_kb, {a, b, c, d}} ->
      [
        {"build #{size_kb}kb resp", fn -> Response.build({:ok, a}) end},
        {"build #{size_kb}kb gzip resp", fn -> Response.build({:ok, b}) end},
        {"build #{size_kb}kb base64 resp", fn -> Response.build({:ok, c}) end},
        {"build #{size_kb}kb gzip base64 resp", fn -> Response.build({:ok, d}) end}
      ]
    end)
    |> List.flatten()
    |> Enum.into(%{})
    |> Benchee.run(time: 2, memory_time: 2)
  end
end
