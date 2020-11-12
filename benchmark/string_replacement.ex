defmodule Benchmark.StringReplacement do
  def run(_) do
    benchmark_string_replacement()
  end

  require EEx
  EEx.function_from_string(:def, :rewrite_func, "/page/section-<%= id %>/video", [:id])

  defp benchmark_string_replacement do
    matcher = BelfrageWeb.ReWrite.prepare("/page/section-:id/video")

    Benchee.run(
      %{
        "eex function from string" => fn -> "/page/section-12345/video" = rewrite_func("12345") end,
        "belfrage rewrite" => fn -> "/page/section-12345/video" = BelfrageWeb.ReWrite.interpolate(matcher, %{"id" => "12345"})  end
      },
      time: 10,
      memory_time: 2
    )
  end
end
