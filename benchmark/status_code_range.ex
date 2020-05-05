defmodule Benchmark.StatusCodeRange do

  def run(_) do
    benchmark_status_code_range()
  end

  defp benchmark_status_code_range do

    status_code_2xx = 202
    status_code_4xx = 418

    Benchee.run(
      %{
        "when not in range" => fn -> status_code_2xx in [400..499] end,
        # "when in range" => fn -> status_code_4xx in [400..499] end,
        "when not between" => fn -> status_code_2xx >= 400 and status_code_2xx <= 499  end,
        # "when is between" => fn -> status_code_4xx >= 400 and status_code_4xx <= 499  end,
      },
      time: 10,
      memory_time: 2
    )
  end
end
