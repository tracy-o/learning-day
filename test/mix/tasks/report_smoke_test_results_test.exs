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
        "test SportHomePage /sport against test belfrage /sport\nassert(response.status_code() == expected_status_code)\nLeft: 404\nRight: 200\nAssertion with == failed",
        "test SportHomePage /sport against test cedric-belfrage /sport\nassert(response.status_code() == expected_status_code)\nLeft: 404\nRight: 200\nAssertion with == failed",
        "test SportHomePage /sport against test bruce-belfrage /sport\nassert(response.status_code() == expected_status_code)\nLeft: 404\nRight: 200\nAssertion with == failed"
      ]
    }

    assert expected == ReportSmokeTestResults.format_failure_messages(failures_per_routespec)
  end

  test "broadcast_results_to_teams/2", %{output_with_failures: output} do
    slack_auth_token = "foobar"

    formatted_messages =
      output
      |> ReportSmokeTestResults.failures_per_routespec()
      |> ReportSmokeTestResults.format_failure_messages()

    assert [
             %Belfrage.Clients.HTTP.Request{
               headers: %{"Authorization" => "Bearer foobar", "Content-Type" => "application/json"},
               method: :post,
               payload: %{
                 channel: "team-belfrage",
                 text: "Smoke test failures",
                 attachments: [
                   %{
                     blocks: [
                       %{
                         block_id: "smoke_test_failure_output",
                         text: %{type: "mrkdwn", text: Enum.join(formatted_messages["SportHomePage"], "\n\n")},
                         type: "section"
                       }
                     ]
                   }
                 ]
               },
               timeout: 6000,
               url: "https://slack.com/api/chat.postMessage"
             }
           ] == ReportSmokeTestResults.broadcast_results_to_teams(formatted_messages, slack_auth_token)
  end
end
