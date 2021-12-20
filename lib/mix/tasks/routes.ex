defmodule Mix.Tasks.Routes do
  use Mix.Task

  @shortdoc "Lists all route matchers. Optional environment [test|live], defaults to live"
  def run([]) do
    run(["test"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} Routes Matchers\n")

    routefile = BelfrageWeb.Routefile.for_cosmos(env)

    Enum.map(routefile.routes(), fn {route_matcher, %{using: route_state_id, examples: examples, only_on: only_on}} ->
      specs = Belfrage.RouteSpec.specs_for(route_state_id, env)
      env = only_on || "live"

      %{
        "Route Matcher" => route_matcher,
        "RouteSpec" => route_state_id,
        "Platform" => specs.platform,
        "Examples" => examples,
        "Runbook" => specs.runbook,
        "Owner" => specs.owner,
        "env" => env
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(only: ["#", "Route Matcher", "RouteSpec", "Platform", "Owner", "env"], style: :github_md)
  end
end
