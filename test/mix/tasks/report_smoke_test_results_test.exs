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
        "*test SportHomePage /sport against test belfrage /sport*\n```\nassert(response.status_code() == expected_status_code)\nAssertion with == failed\nLeft: 404\nRight: 200```",
        "*test SportHomePage /sport against test cedric-belfrage /sport*\n```\nassert(response.status_code() == expected_status_code)\nAssertion with == failed\nLeft: 404\nRight: 200```",
        "*test SportHomePage /sport against test bruce-belfrage /sport*\n```\nassert(response.status_code() == expected_status_code)\nAssertion with == failed\nLeft: 404\nRight: 200```"
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
               headers: %{"authorization" => "Bearer foobar", "content-type" => "application/json"},
               method: :post,
               payload:
                 "{\"attachments\":[{\"blocks\":[{\"block_id\":\"smoke_test_failure_output\",\"text\":{\"text\":\"*test SportHomePage /sport against test belfrage /sport*\\n```\\nassert(response.status_code() == expected_status_code)\\nAssertion with == failed\\nLeft: 404\\nRight: 200```\\n\\n*test SportHomePage /sport against test cedric-belfrage /sport*\\n```\\nassert(response.status_code() == expected_status_code)\\nAssertion with == failed\\nLeft: 404\\nRight: 200```\\n\\n*test SportHomePage /sport against test bruce-belfrage /sport*\\n```\\nassert(response.status_code() == expected_status_code)\\nAssertion with == failed\\nLeft: 404\\nRight: 200```\",\"type\":\"mrkdwn\"},\"type\":\"section\"},{\"elements\":[{\"style\":\"primary\",\"text\":{\"emoji\":true,\"text\":\"Customise slack channel\",\"type\":\"plain_text\"},\"type\":\"button\",\"url\":\"https://github.com/bbc/belfrage/wiki/Direct-smoke-test-failures-to-your-own-slack-channels\"}],\"type\":\"actions\"}]}],\"channel\":\"temp\",\"text\":\"*SportHomePage - Belfrage Smoke Test Failures (3 total)*\"}",
               timeout: 6000,
               url: "https://slack.com/api/chat.postMessage"
             }
           ] == ReportSmokeTestResults.broadcast_results_to_teams(formatted_messages, slack_auth_token)
  end
end
