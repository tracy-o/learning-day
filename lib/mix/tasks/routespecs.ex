defmodule Mix.Tasks.Routespecs do
  use Mix.Task

  @shortdoc "Lists all defined RouteSpecs. Optional environment [test|live], defaults to test"
  def run([]) do
    run(["test"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} RouteSpecs\n")

    routefile = Routes.Routefiles.Test

    routefile.routes()
    |> Enum.uniq_by(fn {_matcher, attrs} -> attrs.using end)
    |> Enum.map(fn {_matcher, %{using: loop_id}} ->
      spec = Belfrage.RouteSpec.specs_for(loop_id, env)

      %{
        "RouteSpec" => loop_id,
        "Platform" => spec.platform,
        "Request Pipeline" => Enum.join(spec.pipeline, ","),
        "Response Pipeline" => Enum.join(spec.resp_pipeline, ",")
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(
      only: ["#", "RouteSpec", "Platform", "Request Pipeline", "Response Pipeline"],
      style: :github_md
    )
  end
end