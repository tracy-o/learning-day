defmodule Benchmark.PreCacheCompressionCall do
  @moduledoc """
  Performance benchmarking of `Belfrage.ResponseTransformers.PreCacheCompression.call/1`
  with two different types of Lambda response: text, gzip.

  ### To run this experiment
  ```
  	$ mix benchmark pre_cache_compression_call # with default 1kb random text content

  	$ mix benchmark pre_cache_compression_call 1 100 # with 100kb payload

  	$ mix benchmark pre_cache_compression_call 2 100 # repeat experiments twice (n times) with increments of 100kb payload
  ```

  ### Expected outcomes
  - performance implication of handling non-gzip response
  """

  import Fixtures.{Struct, Lambda}

  alias Belfrage.Struct
  alias Belfrage.ResponseTransformers.PreCacheCompression
  alias Belfrage.Services.Webcore.Response

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
          struct_with_resp(struct, Response.build({:ok, lambda_resp(size_kb)})),
          struct_with_resp(struct, Response.build({:ok, gzip_lambda_resp(size_kb)}))
        }
      }
    end
  end

  def experiment(iteration \\ 1, step_size_kb \\ 1) do
    setup(iteration, step_size_kb)
    |> Enum.map(fn {size_kb, {a, b}} ->
      [
        {"pre cache compression: #{size_kb}kb lambda resp", fn -> PreCacheCompression.call(a) end},
        {"pre cache compression: #{size_kb}kb lambda gzip resp", fn -> PreCacheCompression.call(b) end}
      ]
    end)
    |> List.flatten()
    |> Enum.into(%{})
    |> Benchee.run(time: 2, memory_time: 2)
  end
end
