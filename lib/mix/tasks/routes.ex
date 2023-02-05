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
    |> Enum.reduce([], fn route, acc -> reduce_route_maps(route, env, acc) end)
    |> Tabula.print_table(only: ["#", "Route Matcher", "RouteSpec", "Platform", "Owner", "env"], style: :github_md)
  end

  defp reduce_route_maps(
         {route_matcher, %{
           using: spec_name,
           platform: platform,
           examples: examples,
           only_on: only_on}},
         env,
         acc
       ) do
    if String.ends_with?(platform, "PlatformSelector") do
      acc
    else
      spec = Belfrage.RouteSpec.get_route_spec({spec_name, platform}, env)
      [%{
         "Route Matcher" => route_matcher,
         "RouteSpec" => spec_name,
         "Platform" => platform,
         "Examples" => examples,
         "Runbook" => spec.runbook,
         "Owner" => spec.owner,
         "env" => only_on || "live"
       } | acc]
    end
  end
end
