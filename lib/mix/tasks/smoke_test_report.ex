defmodule Mix.Tasks.ReportSmokeTestResults do
  use Mix.Task

  @shortdoc "Reports smoke test failures to route owner teams."

  @http_client Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)

  @default_slack_channel "help-belfrage"
  @slack_auth_token_env_var_name "SLACK_AUTH_TOKEN"
  @additional_slack_message_env_var_name "SLACK_MESSAGE"

  @impl Mix.Task
  def run([path_to_raw_input]) do
    Mix.Task.run("app.start")

    test_results = :erlang.binary_to_term(File.read!(path_to_raw_input))

    test_results
    |> failures_per_routespec()
    |> format_failure_messages()
    |> broadcast_results_to_teams(slack_auth_token!())
    |> do_send()
  end

  def run(_), do: IO.puts("Please provide one argument, which is the path to the raw output file.")

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
    Enum.map(errors, fn
      {:error, assertion_error = %ExUnit.AssertionError{}, _context} ->
        assertion = Macro.to_string(assertion_error.expr)

        ~s(*#{failure.name}*
```
#{assertion}
#{assertion_error.message}
Left: #{inspect(assertion_error.left)}
Right: #{inspect(assertion_error.right)}```)

      {:error, %MachineGun.Error{}, _trace} ->
        "Failed to send smoke test request. Contact us in #help-belfrage slack channel."

      error -> inspect("Unexpected error occured:\n\n#{inspect(error)}\n\nContact us in #help-belfrage slack channel.")
    end)
  end

  def broadcast_results_to_teams(formatted_routespec_failures, slack_auth_token) do
    Enum.map(formatted_routespec_failures, &send_slack_message(&1, slack_auth_token))
  end

  defp send_slack_message({routespec, failure_messages}, slack_auth_token) do
    specs = Belfrage.RouteSpec.specs_for(routespec)

    msg = Enum.join(failure_messages, "\n\n")

    slack_channel = Map.get(specs, :slack_channel, @default_slack_channel)

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

  defp do_send(http_requests) do
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
      @default_slack_channel ->
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
