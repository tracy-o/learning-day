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
    |> Enum.map(fn {_matcher, %{using: spec_name, platform: platform}} ->
      spec = Belfrage.RouteSpec.get_route_spec({spec_name, platform}, env)

      %{
        "RouteSpec" => spec_name,
        "Platform" => spec.platform,
        "Request Pipeline" => Enum.join(spec.pipeline, ",")
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(
      only: ["#", "RouteSpec", "Platform", "Request Pipeline", "Response Pipeline"],
      style: :github_md
    )
  end
end
