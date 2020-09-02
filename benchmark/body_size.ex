defmodule Benchmark.BodySize do
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
		benchmark_body_check()
	end

  defp benchmark_body_check do
    IO.puts("Setting up\n")

    string_size = 500

    str = string(string_size)

    Benchee.run(
      %{
        "byte_size" => fn -> byte_size(str) end,
      },
      time: 10,
      memory_time: 2
    )
  end

  defp string(size_in_bytes) do
    :crypto.strong_rand_bytes(size_in_bytes)
    |> Base.encode64()
    |> binary_part(0, size_in_bytes)
  end
end
