defmodule Mix.Tasks.Routes do
  use Mix.Task

  @shortdoc "Lists all route matchers."
  def run(_) do
    Enum.map(Routes.Routefile.routes(), fn {route_matcher, loop_id, examples} ->
      spec = Module.concat([Routes, Specs, loop_id]).specs()
      spec = Map.merge(Module.concat([Routes, Platforms, spec.platform]).specs("live"), spec)

      %{
        "Route Matcher" => route_matcher,
        "RouteSpec" => loop_id,
        "Examples" => examples,
        "Runbook" => spec.runbook,
        "Owner" => spec.owner
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(only: ["#", "Route Matcher", "RouteSpec", "Owner"])
  end
end
