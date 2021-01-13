defmodule Mix.Tasks.ReportSmokeTestResults do
  use Mix.Task

  @shortdoc "Reports smoke test failures to route owner teams."

  @impl Mix.Task
  def run([path_to_raw_input]) do
    test_results = :erlang.binary_to_term(File.read!(path_to_raw_input))

    test_results
    |> failures_per_routespec()
    |> format_failure_messages()
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

  def format_failure_messages(failures_per_routespec) do
    Map.new(failures_per_routespec, &format_routespec_failures/1)
  end

  defp format_routespec_failures({route_spec, failures}) do
    {route_spec, Enum.flat_map(failures, &format_test_failure/1)}
  end

  defp format_test_failure(failure = %ExUnit.Test{state: {:failed, errors}}) do
    Enum.map(errors, fn {:error, assertion_error = %ExUnit.AssertionError{}, _context} ->
      assertion = Macro.to_string(assertion_error.expr)

      ~s(#{failure.name}
#{assertion}
Left: #{assertion_error.left}
Right: #{assertion_error.right}
#{assertion_error.message}\n\n)

    end)
  end
end
