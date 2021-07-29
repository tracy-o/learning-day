defmodule Mix.Tasks.ReportSmokeTestResultsTest do
  use ExUnit.Case
  alias Mix.Tasks.ReportSmokeTestResults

  setup do
    %{
      output_with_failures: Fixtures.SmokeTestReportOutput.with_failures(),
      output_with_exceptions: Fixtures.SmokeTestReportOutput.with_exceptions(),
      with_ex_unit_no_meaningful_value: Fixtures.SmokeTestReportOutput.with_ex_unit_no_meaningful_value()
    }
  end

  test "failures_per_routespec/1", %{output_with_failures: output} do
    expected = %{
      "ScotlandHomePage" => [
        Enum.at(output.failed_tests, 2),
        Enum.at(output.failed_tests, 1),
        Enum.at(output.failed_tests, 0)
      ]
    }

    assert expected == ReportSmokeTestResults.failures_per_routespec(output)
  end

  test "format_failure_messages/1 when smoke tests have detected errors", %{output_with_failures: output} do
    failures_per_routespec = ReportSmokeTestResults.failures_per_routespec(output)

    expected = %{
      "ScotlandHomePage" => [
        "test ScotlandHomePage /scotland against test belfrage /scotland\n\n```Assertion with == failed\ncode:  assert response.status_code() == expected_status_code\nleft:  404\nright: 200\n```",
        "test ScotlandHomePage /scotland against test cedric-belfrage /scotland\n\n```Assertion with == failed\ncode:  assert response.status_code() == expected_status_code\nleft:  404\nright: 200\n```",
        "test ScotlandHomePage /scotland against test bruce-belfrage /scotland\n\n```Assertion with == failed\ncode:  assert response.status_code() == expected_status_code\nleft:  404\nright: 200\n```"
      ]
    }

    assert expected == ReportSmokeTestResults.format_failure_messages(failures_per_routespec)
  end

  test "format_failure_messages/1 when right & left values are :ex_unit_no_meaningful_value", %{
    with_ex_unit_no_meaningful_value: output
  } do
    failures_per_routespec = ReportSmokeTestResults.failures_per_routespec(output)

    expected = %{
      "WorldServiceTajik" => [
        "test WorldServiceTajik /tajik.amp against test bruce-belfrage /tajik.amp\n\n```Expected `location` response header to be set for world service redirect.\n```",
        "test WorldServiceTajik /tajik.json against test bruce-belfrage /tajik.json\n\n```Expected `location` response header to be set for world service redirect.\n```",
        "test WorldServiceTajik /tajik/*_any against test bruce-belfrage /tajik\n\n```Expected `location` response header to be set for world service redirect.\n```"
      ]
    }

    assert expected == ReportSmokeTestResults.format_failure_messages(failures_per_routespec)
  end

  test "format_failure_messages/1 when smoke test itself breaks", %{
    output_with_exceptions: output
  } do
    failures_per_routespec = ReportSmokeTestResults.failures_per_routespec(output)

    expected = %{
      "Schoolreport" => ["Failed to send smoke test request. Contact us in #help-belfrage slack channel."],
      "Weather" => ["Unexpected error occured. Contact us in #help-belfrage slack channel."]
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
               timeout: 6000,
               url: "https://slack.com/api/chat.postMessage",
               payload:
                 "{\"attachments\":[{\"blocks\":[{\"block_id\":\"smoke_test_failure_output\",\"text\":{\"text\":\"test ScotlandHomePage /scotland against test belfrage /scotland\\n\\n```Assertion with == failed\\ncode:  assert response.status_code() == expected_status_code\\nleft:  404\\nright: 200\\n```\\n\\ntest ScotlandHomePage /scotland against test cedric-belfrage /scotland\\n\\n```Assertion with == failed\\ncode:  assert response.status_code() == expected_status_code\\nleft:  404\\nright: 200\\n```\\n\\ntest ScotlandHomePage /scotland against test bruce-belfrage /scotland\\n\\n```Assertion with == failed\\ncode:  assert response.status_code() == expected_status_code\\nleft:  404\\nright: 200\\n```\",\"type\":\"mrkdwn\"},\"type\":\"section\"},{\"elements\":[{\"style\":\"primary\",\"text\":{\"emoji\":true,\"text\":\"Customise slack channel\",\"type\":\"plain_text\"},\"type\":\"button\",\"url\":\"https://github.com/bbc/belfrage/wiki/Direct-smoke-test-failures-to-your-own-slack-channels\"}],\"type\":\"actions\"}]}],\"channel\":\"help-belfrage\",\"text\":\"*ScotlandHomePage - Belfrage Smoke Test Failures (3 total)*\"}"
             }
           ] == ReportSmokeTestResults.broadcast_results_to_teams(formatted_messages, slack_auth_token)
  end
end
