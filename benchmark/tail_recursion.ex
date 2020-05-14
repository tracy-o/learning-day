defmodule Benchmark.TailRecursion do
  defmodule Testable do
    def recursive_map([], acc), do: acc
    def recursive_map([value | rest], acc) do
      recursive_map(rest, [value + 1 | acc])
    end

    def enum_map(numbers) do
      Enum.map(numbers, &(&1 + 1))
    end
  end

  def run(_) do
    benchmark_tail_recursion(Enum.to_list(1..10))
    benchmark_tail_recursion(Enum.to_list(1..50))
  end

  defp benchmark_tail_recursion(list) do
    Benchee.run(
      %{
        "tail recursion (#{Enum.count(list)})" => fn -> Testable.recursive_map(list, []) end,
        "Enum.map/2 (#{Enum.count(list)})" => fn -> Testable.enum_map(list) end,
      },
      time: 10,
      memory_time: 2
    )
  end
end
