defmodule Mix.Tasks.Routes do
  use Mix.Task

  @shortdoc "Lists all route matchers. Optional environment [test|live], defaults to live"
  def run([]) do
    run(["test"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} Routes Matchers\n")

    routefile = BelfrageWeb.Routefile.for_cosmos(env)

    Enum.map(routefile.routes(), fn {route_matcher, %{using: spec_name, platform: platform, examples: examples, only_on: only_on}} ->
      spec = Belfrage.RouteSpec.get_route_spec({spec_name, platform}, env)
      env = only_on || "live"

      %{
        "Route Matcher" => route_matcher,
        "RouteSpec" => spec_name,
        "Platform" => spec.platform,
        "Examples" => examples,
        "Runbook" => spec.runbook,
        "Owner" => spec.owner,
        "env" => env
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(only: ["#", "Route Matcher", "RouteSpec", "Platform", "Owner", "env"], style: :github_md)
  end
end
