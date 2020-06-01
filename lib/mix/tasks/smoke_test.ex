defmodule Mix.Tasks.SmokeTest do
  use Mix.Task

  @env_opt "--bbc-env"
  @shortdoc "Smoke tests mix task for Belfrage example routes"

  @moduledoc """
  Runs sanity and smoke tests on Belfrage example routes.

  This task runs the smoke tests in test/smoke/ directory for all 
  or subsets of Belfage example routes via a list `mix test` options.

  ## Command line options
    
    * `--bbc-env` - specify the Cosmos production environment to run the tests on, either `test` or `live` 
    * `--only` - runs only tests that match the filter. See "Test route subset with `--only`" below
    * all other [`mix test` options](https://hexdocs.pm/mix/Mix.Tasks.Test.html#module-command-line-options)

  ## Examples

  Tests all routes (currently all Webcore routes)

      mix smoke_test

  Perform sanity check (5 tests)
    
      mix smoke_test --only sanity

  Using other `mix test` options, e.g. increase verbosity and outputs all test
  details with timing, as well as identify the slowest (3) tests

      mix smoke_test --trace --color --slowest 3

  ## Test route subsets with `--only`

  Platform:

      mix smoke_test --only platform:Webcore
      mix smoke_test --only platform:Pal

  Spec:

      mix smoke_test --only spec:Search
      mix smoke_test --only spec:TopicPage
      mix smoke_test --only spec:SportPal

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

  @impl Mix.Task
  def run(args) when is_list(args) do
    cmd =
      case parse(args) do
        {[], parsed_args} ->
          "MIX_ENV=smoke_test mix test #{Enum.join(parsed_args, " ")}"

        {[@env_opt], parsed_args} ->
          "MIX_ENV=smoke_test mix test #{Enum.join(parsed_args, " ")}"

        {[@env_opt, env], parsed_args} ->
          "SMOKE_ENV=#{env} MIX_ENV=smoke_test mix test #{Enum.join(parsed_args, " ")}"
      end

    run(cmd)
  end

  def run(cmd) when is_binary(cmd), do: Mix.shell().cmd(cmd)

  defp parse(args, env \\ [], acc \\ [])

  defp parse([], env, acc), do: {env, acc}

  defp parse([h | t], [@env_opt], acc) do
    case String.starts_with?(h, "--") do
      true -> parse(t, [], acc ++ [h])
      false -> parse(t, [@env_opt, h], acc)
    end
  end

  defp parse([h | t], _env, acc) when h == @env_opt, do: parse(t, [@env_opt], acc)
  defp parse([h | t], env, acc), do: parse(t, env, acc ++ [h])
end
