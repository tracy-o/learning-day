defmodule Mix.Tasks.ReportSmokeTestResults do
  use Mix.Task

  @shortdoc "Reports smoke test failures to route owner teams."

  @impl Mix.Task
  def run([path_to_raw_input]) do
    test_results = :erlang.binary_to_term(File.read!(path_to_raw_input))

    test_results
    |> failures_per_routespec()
  end

  def run(_), do: IO.puts "Please provide one argument, which is the path to the raw output file."

  def failures_per_routespec(_test_results = %{failed_tests: failed_tests}) do
    Enum.reduce(failed_tests, %{}, fn failure, acc ->

      route_spec = get_in(failure, [Access.key(:tags), Access.key(:spec)])

      update_in(acc, [route_spec], fn
        nil -> [failure]
        current_failures when is_list(current_failures) -> [failure | current_failures]
      end)
    end)
  end
end
