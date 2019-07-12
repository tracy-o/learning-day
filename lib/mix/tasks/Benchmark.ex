defmodule Mix.Tasks.Benchmark do
  use Mix.Task
  alias Belfrage.{Struct, Processor}

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    benchmark_get_loop()
    benchmark_request_pipeline()
    benchmark_response_pipeline()
    benchmark_memory_check()
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

  defp benchmark_memory_check do
    :ets.new(:benchmark_table, [:set, :protected, :named_table, read_concurrency: true])

    Enum.each(1..10_000, fn i -> :ets.insert(:benchmark_table, {i, random_string()}) end)

    Benchee.run(
      %{
        "memsup" => fn -> :memsup.get_system_memory_data() end,
        "ets.get_inf" => fn -> :memsup.get_system_memory_data() end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp random_string do
    # between 1kb and 2mb
    size_in_bytes = (:rand.uniform(2_047) + 1) * 1024

    :crypto.strong_rand_bytes(size_in_bytes)
    |> Base.encode64()
    |> binary_part(0, size_in_bytes)
  end
end
