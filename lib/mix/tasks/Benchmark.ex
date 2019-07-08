defmodule Mix.Tasks.Benchmark do
  use Mix.Task
  alias Belfrage.{Struct, Processor}

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    benchmark_get_loop()
    benchmark_request_pipeline()
    benchmark_response_pipeline()
  end

  defp benchmark_get_loop do
    struct = %Struct{private: %Struct.Private{loop_id: ["test_loop_id"]}}

    Benchee.run(
      %{
        "Processor.get_loop" => fn -> Processor.get_loop(struct) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp benchmark_request_pipeline do
    struct = %Struct{
      private: %Struct.Private{pipeline: ["MyTransformer1"], loop_id: ["test_loop_id"]}
    }

    Benchee.run(
      %{
        "Processor.request_pipeline" => fn -> Processor.request_pipeline(struct) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp benchmark_response_pipeline do
    struct = %Struct{
      private: %Struct.Private{pipeline: ["MyTransformer1"], loop_id: ["test_loop_id"]}
    }

    Benchee.run(
      %{
        "Processor.response_pipeline" => fn -> Processor.response_pipeline(struct) end
      },
      time: 10,
      memory_time: 2
    )
  end
end
