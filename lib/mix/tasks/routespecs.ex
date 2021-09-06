defmodule Mix.Tasks.Routespecs do
  use Mix.Task

  @shortdoc "Lists all route matchers. Optional environment [test|live], defaults to live"
  def run([]) do
    run(["test"])
  end

  def run([env]) do
    IO.puts("# Belfrage #{env} RouteSpecs\n")

    routefile = Routes.Routefile

    routefile.routes()
    |> Enum.uniq_by(fn {_matcher, attrs} -> attrs.using end)
    |> Enum.map(fn {_matcher, %{using: loop_id}} ->
      spec = Belfrage.RouteSpec.specs_for(loop_id, env)

      %{
        "RouteSpec" => loop_id,
        "Platform" => spec.platform,
        "req_pipeline" => Enum.join(spec.pipeline, ","),
        "resp_pipeline" => Enum.join(spec.resp_pipeline, ",")
      }
    end)
    |> Enum.reverse()
    |> Tabula.print_table(only: ["#", "RouteSpec", "Platform", "req_pipeline", "resp_pipeline"], style: :github_md)
  end
end
