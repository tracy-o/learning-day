defmodule Mix.Tasks.ReportSmokeTestResultsTest do
  use ExUnit.Case
  alias Mix.Tasks.ReportSmokeTestResults

  setup do
    %{
      output_with_failures: Fixtures.SmokeTestReportOutput.with_failures()
    }
  end

  test "failures_per_routespec/1", %{output_with_failures: output} do
    expected = %{
      "SportHomePage" => [
        Enum.at(output.failed_tests, 2),
        Enum.at(output.failed_tests, 1),
        Enum.at(output.failed_tests, 0)
      ]
    }

    assert expected == ReportSmokeTestResults.failures_per_routespec(output)
  end

  test "format_failure_messages/1", %{output_with_failures: output} do
    failures_per_routespec = ReportSmokeTestResults.failures_per_routespec(output)

    expected = %{
      "SportHomePage" => [
        "test SportHomePage /sport against test belfrage /sport\nassert(response.status_code() == expected_status_code)\nLeft: 404\nRight: 200\nAssertion with == failed\n\n",
        "test SportHomePage /sport against test cedric-belfrage /sport\nassert(response.status_code() == expected_status_code)\nLeft: 404\nRight: 200\nAssertion with == failed\n\n",
        "test SportHomePage /sport against test bruce-belfrage /sport\nassert(response.status_code() == expected_status_code)\nLeft: 404\nRight: 200\nAssertion with == failed\n\n"
      ]
    }

    assert expected == ReportSmokeTestResults.format_failure_messages(failures_per_routespec)
  end
end

Macro.to_string(
  {:assert, [],
   [
     {:==, [],
      [
        {{:., [], [{:response, [], nil}, :status_code]}, [], []},
        {:expected_status_code, [], nil}
      ]}
   ]}
)
