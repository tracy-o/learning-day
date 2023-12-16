defmodule Mix.Tasks.RouteSpecGen do
  @shortdoc "Generates a new route spec. Optional arg --personalised."

  @route_spec_template """
  defmodule Routes.Specs.{{ route_spec.name }} do
    def specification do
      %{
        specs: [
          {{ route_spec.specs }}
        ]
      }
    end
  end
  """

  @personalised_route_spec_template """
  defmodule Routes.Specs.{{ route_spec.name }} do
    def specification do
      %{
        preflight_pipeline: [],
        specs: [
          {{ route_spec.specs }}
        ]
      }
    end
  end
  """

  @platform_template """
  %{
    email: "Please type your team's EMAIL here",
    slack_channel: "Please type your team's SLACK CHANNEL here",
    runbook: "Please link the relevant RUNBOOK here",
    platform: "{{ platform.name }}",
    examples: []
  }
  """

  @aliases [n: :name, m: :mock]
  @strict_args [{:name, :string}, {:platforms, :string}, {:personalised, :boolean}, {:mock, :boolean}]

  use Mix.Task

  def run(args) do
    {valid_args, _, _} = OptionParser.parse(args, aliases: @aliases, strict: @strict_args)
    {name, content} = fill_template(valid_args)
    generate_file(name, content)
  end

  defp fill_template(platforms: platforms) do
    {:ok, template} =
      @platform_template
      |> String.replace("\n", "")
      |> Solid.parse()

    platforms
    |> String.split(",", trim: true)
    |> Enum.map_join(",\n", fn platform ->
      Solid.render!(template, %{"platform" => %{"name" => platform}})
    end)
  end

  defp fill_template(opts) do
    t = if opts[:personalised], do: @personalised_route_spec_template, else: @route_spec_template
    {:ok, template} = Solid.parse(t)

    content =
      template
      |> Solid.render!(%{
        "route_spec" => %{"name" => opts[:name], "specs" => fill_template(platforms: opts[:platforms])}
      })
      |> to_string()

    {opts[:name], content}
  end

  defp generate_file(name, content) do
    path_to_file = "lib/routes/specs/" <> Macro.underscore(name) <> ".ex"

    if File.exists?(path_to_file) do
      raise "File already exists! Please try another name."
    else
      File.write!(path_to_file, Code.format_string!(content))
    end
  end
end
