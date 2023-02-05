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
    |> Enum.reduce([], fn route, acc -> reduce_route_maps(route, env, acc) end)
    |> Tabula.print_table(
      only: ["#", "RouteSpec", "Platform", "Request Pipeline", "Response Pipeline"],
      style: :github_md
    )
  end

  defp reduce_route_maps({_matcher, %{using: spec_name, platform: platform}}, env, acc) do
    if String.ends_with?(platform, "PlatformSelector") do
      acc
    else
      spec = Belfrage.RouteSpec.get_route_spec({spec_name, platform}, env)
      [%{
         "RouteSpec" => spec_name,
         "Platform" => platform,
         "Request Pipeline" => Enum.join(spec.pipeline, ",")
       } | acc]
    end
  end
end
