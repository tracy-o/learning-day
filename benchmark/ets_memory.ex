defmodule Benchmark.EtsMemory do
  def run([test_size]), do: benchmark_memory_check(test_size |> String.to_integer())

  def run(_) do 
    {:ok, _started} = Application.ensure_all_started(:belfrage)
		benchmark_memory_check()
	end

  defp benchmark_memory_check(test_size \\ 5_000) do
    IO.puts("Setting up\n")

    :ets.new(:benchmark_table, [:set, :protected, :named_table, read_concurrency: true])

    Enum.each(1..test_size, fn i -> :ets.insert(:benchmark_table, {i, random_string()}) end)

    Benchee.run(
      %{
        "memsup" => fn -> :memsup.get_system_memory_data() end,
        # Sadly the memory used by ets only includes pointers to the Strings, so is much smaller than the "real" memory usage
        "ets.info" => fn -> :ets.info(:benchmark_table) end,
        ":erlang.memory" => fn -> :erlang.memory() end
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
