defmodule Mix.Tasks.Routespecs do
  use Mix.Task

  @shortdoc "Lists all defined RouteSpecs. Optional environment [test|live], defaults to test"
  def run([]) do
    run(["test"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} RouteSpecs\n")

    # TODO: Update how we reference the routefile to include others
    routefile = Routes.Routefiles.Main.Test

    routefile.routes()
    |> Enum.uniq_by(fn {_matcher, attrs} -> attrs.using end)
    |> Enum.reduce([], fn route, acc -> get_route_maps(route, env) ++ acc end)
    |> Tabula.print_table(
      only: ["#", "RouteSpec", "Platform", "Request Pipeline", "Response Pipeline"],
      style: :github_md
    )
  end

  defp get_route_maps({_matcher, %{using: spec_name}}, env) do
    %{specs: specs} = Belfrage.RouteSpec.get_route_spec(spec_name, env)

    for spec <- specs, do: %{
      "RouteSpec" => spec_name,
      "Platform" => spec.platform,
      "Request Pipeline" => Enum.join(spec.pipeline, ",")
    }
  end
end
