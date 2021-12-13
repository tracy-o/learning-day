defmodule Benchmark.ResponsePipeline do
  @moduledoc """
  Performance benchmarking of `Belfrage.Processor.response_pipeline/1`
  for non-gzip and gzip (base64 encoded) origin responses

  ### To run this experiment
  ```
  	$ mix benchmark response_pipeline # with default 1kb random text content

  	$ mix benchmark response_pipeline 1 100 # with 100kb payload

  	$ mix benchmark response_pipeline 3 100 # repeat experiments 3 (nth) times with increments of 100kb payload
  ```

  ### Expected outcomes
   Handling of raw (uncompressed) and gzip (base64 encoded) content incur performance costs in different 
   parts of the response pipeline: base64 decoding and pre-cache gzipping. This experiment
  should inform us which of the two processes incurs larger performance cost. 

  	- Comparing the performance of Belfrage response pipeline: raw vs gzip base 64 responses
  	- raw lambda response: - base64 decoding, + pre-cache gzipping
  	- gzip base64 lambda response: + base64 decoding, - pre-cache gzipping
  """

  import Fixtures.{Struct, Lambda}

  alias Belfrage.Struct
  alias Belfrage.Processor
  alias Belfrage.Services.Webcore

  # TODO: see webcore_response_build.ex

  def run([iteration]), do: experiment(iteration |> String.to_integer())
  def run([iteration, step_size]), do: experiment(iteration |> String.to_integer(), step_size |> String.to_integer())

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    experiment()
  end

  def setup(iteration \\ 1, step_size_kb \\ 1) do
    struct = %Struct{
      private: %Struct.Private{pipeline: ["MyTransformer1"], loop_id: "ProxyPass"}
    }

    for i <- 1..iteration, into: %{} do
      size_kb = i * step_size_kb

      {
        size_kb,
        {
          struct_with_resp(struct, Webcore.build_response({:ok, lambda_resp(size_kb)})),
          struct_with_resp(struct, Webcore.build_response({:ok, gzip_base64_lambda_resp(size_kb)}))
        }
      }
    end
  end

  def experiment(iteration \\ 1, step_size_kb \\ 1) do
    setup(iteration, step_size_kb)
    |> Enum.map(fn {size_kb, {a, b}} ->
      [
        {"Processor.response_pipeline #{size_kb}kb resp", fn -> Processor.response_pipeline(a) end},
        {"Processor.response_pipeline #{size_kb}kb gzip base64 resp", fn -> Processor.response_pipeline(b) end}
      ]
    end)
    |> List.flatten()
    |> Enum.into(%{})
    |> Benchee.run(time: 2, memory_time: 2)
  end
end
