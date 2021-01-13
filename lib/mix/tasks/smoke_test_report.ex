defmodule Mix.Tasks.ReportSmokeTestResults do
  use Mix.Task

  @shortdoc "Reports smoke test failures to route owner teams."

  @http_client Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)

  @slack_auth_token_env_var_name "SLACK_AUTH_TOKEN"

  @impl Mix.Task
  def run([path_to_raw_input]) do
    # :ok = Application.start(:belfrage)
     Mix.Task.run("app.start")


    test_results = :erlang.binary_to_term(File.read!(path_to_raw_input))

    slack_auth_token = System.fetch_env!(@slack_auth_token_env_var_name)

    test_results
    |> failures_per_routespec()
    |> format_failure_messages()
    |> broadcast_results_to_teams(slack_auth_token)
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
    Enum.map(errors, fn {:error, assertion_error = %ExUnit.AssertionError{}, _context} ->
      assertion = Macro.to_string(assertion_error.expr)

      ~s(*#{failure.name}*
```
#{assertion}
#{assertion_error.message}
Left: #{assertion_error.left}
Right: #{assertion_error.right}```)
    end)
  end

  def broadcast_results_to_teams(formatted_routespec_failures, slack_auth_token) do
    Enum.map(formatted_routespec_failures, &send_slack_message(&1, slack_auth_token))
  end

  defp send_slack_message({routespec, failure_messages}, slack_auth_token) do
    specs = Belfrage.RouteSpec.specs_for(routespec)

    msg = Enum.join(failure_messages, "\n\n")

    %Belfrage.Clients.HTTP.Request{
      method: :post,
      url: "https://slack.com/api/chat.postMessage",
      headers: %{
        "content-type" => "application/json",
        "authorization" => "Bearer #{slack_auth_token}"
      },
      payload: Jason.encode!(%{
        text: "*#{routespec} - Belfrage Smoke Test Failures (#{Enum.count(failure_messages)} total)*",
        # TODO change team-belfrage to help-belfrage when this is ready to be used.
        channel: Map.get(specs, :smoke_test_failure_channel, "temp"),
        attachments: [
          %{
            blocks: [
              %{
                type: "section",
                text: %{
                  type: "mrkdwn",
                  text: msg
                },
                block_id: "smoke_test_failure_output"
              }
            ]
          }
        ]
      })
    }
  end

  defp do_send(http_requests) do
    Enum.each(http_requests, fn req ->
      @http_client.execute(req)
      |> IO.inspect()
    end)
  end
end
