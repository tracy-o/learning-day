defmodule Mix.Tasks.SmokeTest do
  use Mix.Task

  @shortdoc "Smoke tests mix task for Belfrage example routes"

  @moduledoc """
  Runs smoke tests on Belfrage example routes.

  This task runs the smoke tests in test/smoke/ directory for all
  or subsets of Belfage example routes via a list `mix test` options.

  ## Command line options

    * `--bbc-env` - specify the Cosmos production environment to run the tests on, either `test` or `live`
    * `--only` - runs only tests that match the filter. See "Test route subset with `--only`" below
    * all other [`mix test` options](https://hexdocs.pm/mix/Mix.Tasks.Test.html#module-command-line-options)

  ## Examples

  Tests all routes (currently all Webcore routes)

      mix smoke_test

  Perform chimney check (5 tests)

      mix smoke_test --only chimney

  Using other `mix test` options, e.g. increase verbosity and outputs all test
  details with timing, as well as identify the slowest (3) tests

      mix smoke_test --trace --color --slowest 3

  ## Test route subsets with `--only`

  Platform:

      mix smoke_test --only platform:Webcore

  Spec:

      mix smoke_test --only spec:Search
      mix smoke_test --only spec:TopicPage

  Belfrage stack:

      mix smoke_test --only stack:cedric-belfrage
      mix smoke_test --only stack:bruce-belfrage

  Specific route:

      mix smoke_test --only route:/scotland
      mix smoke_test --only route:/news/videos/:id
      mix smoke_test --only route:/topics/:id

  ## Specify Cosmos environment via `--bbc-env`

  "test" (default)

       mix smoke_test
       mix smoke_test --bbc-env test

  "live"

       mix smoke_test --bbc-env live

  """

  @custom_opts_parse_rules [{:group_by, :string}, {:bbc_env, :string}]
  @standard_mix_test_parse_rules [{:color, :boolean}, {:only, :string}, {:slowest, :string}]

  @impl Mix.Task
  def run(args) when is_list(args) do
    {parsed_args, _, _} = OptionParser.parse(args, strict: @custom_opts_parse_rules ++ @standard_mix_test_parse_rules)

    {group_by, rest} = Keyword.pop(parsed_args, :group_by)
    {bbc_env, rest} = Keyword.pop(rest, :bbc_env)

    case {group_by, bbc_env} do
      {nil, nil} -> "MIX_ENV=smoke_test mix test #{join_params(rest)} --formatter JoeFormatter"
      {nil, bbc_env} -> "SMOKE_ENV=#{bbc_env} MIX_ENV=smoke_test mix test #{join_params(rest)} --formatter JoeFormatter"
      {group_by, nil} -> "GROUP_BY=#{group_by} MIX_ENV=smoke_test mix test #{join_params(rest)} --formatter JoeFormatter"
      {group_by, bbc_env} -> "GROUP_BY=#{group_by} SMOKE_ENV=#{bbc_env} MIX_ENV=smoke_test mix test #{join_params(rest)} --formatter JoeFormatter"
    end
    |> run()
  end

  def run(cmd) when is_binary(cmd) do
    exit_code = Mix.shell().cmd(cmd)
    exit({:shutdown, exit_code})
  end

  defp join_params(keyword_list) do
    Enum.reduce(keyword_list, "", fn {k, v}, acc ->
      acc <> " --#{k} #{v}"
    end)
  end
end
