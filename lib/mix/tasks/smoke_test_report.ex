defmodule Mix.Tasks.ReportSmokeTestResults do
  use Mix.Task

  alias Mix.Tasks.ReportSmokeTestResults.Message

  @shortdoc "Reports smoke test failures to route owner teams."

  @http_client Application.compile_env(:belfrage, :http_client, Belfrage.Clients.HTTP)


  # Result of smoke tests are only send if at least one test fails.
  #
  # When a failure occurs a notification is sent to the team-belfrage channel.
  # This notification contains the total smoke test failures and a link to the
  # #belfrage-smoke-tests channel to see what they are.
  #
  # In the #belfrage-smoke-test channel it shows each failure and why that smoke
  # test is failing.
  #
  # There is a mechanism to send messages to teams if their smoke tests are
  # failing. This is done by specifying a 'slack_channel' in the routespec. It
  # would also require them to invite moz to their slack channel. for more info
  # see here: https://github.com/bbc/belfrage/pull/670
  @results_slack_channel "belfrage-smoke-tests"
  @results_slack_channel_link "<#C029V08H8NB>"
  @notification_slack_channel "team-belfrage"

  @slack_auth_token_env_var_name "SLACK_AUTH_TOKEN"
  @additional_slack_message_env_var_name "SLACK_MESSAGE"

  @impl Mix.Task
  def run([path_to_raw_input]) do
    Mix.Task.run("app.start")

    test_results = :erlang.binary_to_term(File.read!(path_to_raw_input))

    test_results
    |> notify_main_channel(slack_auth_token!())
    |> send()

    test_results
    |> failures_per_routespec()
    |> format_failure_messages()
    |> broadcast_results_to_teams(slack_auth_token!())
    |> send()
  end

  def run(_) do
    IO.puts("Please provide one argument, which is the path to the raw output file.")
  end

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
    Enum.map(errors, &Message.format(failure, &1))
  end

  def notify_main_channel(test_results, slack_auth_token) do
    failures = test_results.failure_counter
    fallbacks = test_results.fallback_count
    total_tests = test_results.test_counter.test

    if failures > 0 do
      ~s|:dash: *Smoke Test Failure: #{failures}/#{total_tests}* (fallbacks=#{fallbacks}) :dash:\n\nfor details see #{@results_slack_channel_link}|
      |> build_slack_notification_message(@notification_slack_channel, slack_auth_token)
    else
      []
    end
  end

  @spec broadcast_results_to_teams(any, any) :: list
  def broadcast_results_to_teams(formatted_routespec_failures, slack_auth_token) do
    Enum.map(formatted_routespec_failures, &build_result_message(&1, slack_auth_token))
  end

  defp build_result_message({routespec, failure_messages}, slack_auth_token) do
    slack_channel = Belfrage.RouteSpec.specs_for(routespec).slack_channel || @results_slack_channel

    msg = Enum.join(failure_messages, "\n\n")

    %Belfrage.Clients.HTTP.Request{
      method: :post,
      url: "https://slack.com/api/chat.postMessage",
      headers: %{
        "content-type" => "application/json",
        "authorization" => "Bearer #{slack_auth_token}"
      },
      payload:
        Jason.encode!(%{
          text: "*#{routespec} - Belfrage Smoke Test Failures (#{Enum.count(failure_messages)} total)*",
          channel: slack_channel,
          attachments:
            [
              %{
                blocks:
                  [
                    %{
                      type: "section",
                      text: %{type: "mrkdwn", text: msg},
                      block_id: "smoke_test_failure_output"
                    }
                  ] ++ how_to_send_to_own_channel(slack_channel)
              }
            ] ++ additional_slack_message()
        })
    }
  end

  defp build_slack_notification_message(message, slack_channel, slack_auth_token) do
    [
      %Belfrage.Clients.HTTP.Request{
      method: :post,
      url: "https://slack.com/api/chat.postMessage",
      headers: %{
        "content-type" => "application/json",
        "authorization" => "Bearer #{slack_auth_token}"
      },
      payload:
        Jason.encode!(%{
          blocks: [%{
            type: "section",
            text: %{type: "mrkdwn", text: message}
          }],
          channel: slack_channel
        })
    }
  ]
  end

  defp send(http_requests) do
    Enum.each(http_requests, &@http_client.execute/1)
  end

  defp slack_auth_token! do
    case System.get_env(@slack_auth_token_env_var_name) do
      nil -> raise "Required environment variable `#{@slack_auth_token_env_var_name}` not set."
      token -> token
    end
  end

  defp additional_slack_message do
    case System.get_env(@additional_slack_message_env_var_name) do
      nil ->
        []

      message ->
        [
          %{
            text: message
          }
        ]
    end
  end

  defp how_to_send_to_own_channel(channel) do
    case channel do
      @results_slack_channel ->
        [
          %{
            type: "actions",
            elements: [
              %{
                type: "button",
                style: "primary",
                text: %{
                  type: "plain_text",
                  text: "Customise slack channel",
                  emoji: true
                },
                url: "https://github.com/bbc/belfrage/wiki/Direct-smoke-test-failures-to-your-own-slack-channels"
              }
            ]
          }
        ]

      _other ->
        []
    end
  end
end
