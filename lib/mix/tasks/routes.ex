defmodule Mix.Tasks.Routes do
  use Mix.Task

  @shortdoc "Lists all route matchers. Optional environment [test|live], defaults to live"
  def run([]) do
    run(["live"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} Routes Matchers\n")

    routefile = BelfrageWeb.Routefile.for_cosmos(env)

    Enum.map(routefile, fn {route_matcher, %{using: loop_id, examples: examples}} ->
      specs = Belfrage.RouteSpec.specs_for(loop_id, env)

      %{
        "Route Matcher" => route_matcher,
        "RouteSpec" => loop_id,
        "Examples" => examples,
        "Runbook" => specs.runbook,
        "Owner" => specs.owner
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(only: ["#", "Route Matcher", "RouteSpec", "Owner"], style: :github_md)
  end
end
