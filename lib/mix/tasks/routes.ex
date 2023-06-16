defmodule Mix.Tasks.Routes do
  use Mix.Task

  @shortdoc "Lists all route matchers. Optional environment [test|live], defaults to live"
  def run([]) do
    run(["test"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} Routes Matchers\n")

    routefile = BelfrageWeb.Routefile.for_cosmos(env)

    routefile.routes()
    |> Enum.reduce([], fn route, acc -> get_route_maps(route, env) ++ acc end)
    |> Tabula.print_table(only: ["#", "Route Matcher", "RouteSpec", "Platform", "Owner", "env"], style: :github_md)
  end

  defp get_route_maps(
         {route_matcher, %{
           using: spec_name,
           only_on: only_on}},
         env
       ) do
    %{specs: specs} = Belfrage.RouteSpec.get_route_spec(spec_name, env)

    for spec <- specs, do: %{
      "Route Matcher" => route_matcher,
      "RouteSpec" => spec_name,
      "Platform" => spec.platform,
      "Runbook" => spec.runbook,
      "Owner" => spec.owner,
      "env" => only_on || "live"
    }
  end
end
