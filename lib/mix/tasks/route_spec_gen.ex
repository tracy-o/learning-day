defmodule Mix.Tasks.RouteSpecGen do
  @shortdoc "Generates a new route spec. Optional arg --personalised."

  @route_spec_template """
  defmodule Routes.Specs.{{ route_spec.name }} do
    def specification do
      %{
        specs: {{ route_spec.specs }}    }
    end
  end
  """

  @personalised_route_spec_template """
  defmodule Routes.Specs.{{ route_spec.name }} do
    def specification do
      %{
        preflight_pipeline: {{ route_spec.preflight_pipeline }}
        specs: [
          {{ route_spec.specs }}]
      }
    end
  end
  """

  @platform_template """
  %{
    email: "example-email@bbc.co.uk",
    runbook: "https://confluence.dev.bbc.co.uk/%Example%20-%20Runbook",
    platform: "{{ platform.name }}",
    examples: []
  }
  """

  use Mix.Task

  def run(["--route_spec", route_spec, "--platform", platform]) do
    build_template(route_spec: route_spec, platform: platform)
    |> to_string()
    |> IO.puts()
  end

  def run(["--platform", platform]) do
    build_template(platform: platform)
    |> to_string()
    |> IO.puts()
  end

  def run(_), do: nil

  defp build_template(route_spec: route_spec, platform: platform) do
    {:ok, route_spec_template} = Solid.parse(@route_spec_template)
    Solid.render!(route_spec_template, %{"route_spec" => %{"name" => route_spec, "specs" => build_template(platform: platform)}})
  end

  defp build_template([platform: platform]) do
    {:ok, template} = Solid.parse(@platform_template)
    Solid.render!(template, %{"platform" => %{"name" => platform}})
  end
end
