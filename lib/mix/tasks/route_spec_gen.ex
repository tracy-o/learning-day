defmodule Mix.Tasks.RouteSpecGen do
  @shortdoc "Generates a new route spec. Optional args [--personalised,."

  @spec_dirs %{
    lib: "lib/routes/specs/",
    mock: "test/support/mocks/routes/specs/"
  }

  @aliases [n: :name, m: :mock]
  @strict_args [{:name, :string}, {:platforms, :string}, {:personalised, :boolean}, {:mock, :boolean}]

  use Mix.TaskAssets.RouteSpecTemplates
  use Mix.Task

  def run(args) do
    {valid_args, _, _} = OptionParser.parse(args, aliases: @aliases, strict: @strict_args)

    parsed_args =
      unless valid_args[:name] do
        interactive_mode()
      else
        parse_args(valid_args)
      end

    {module_name, content} = fill_template(parsed_args[:name], parsed_args[:platforms], parsed_args[:template_type])
    generate_file(module_name, content, parsed_args[:file_type])
  end

  defp parse_args(opts) do
    %{
      name: opts[:name],
      platforms: String.split(opts[:platforms], [",", " "], trim: true),
      template_type: template_type(opts[:personalised]),
      file_type: file_type(opts[:mock])
    }
  end

  defp interactive_mode() do
    name = user_input("Name (e.g NewRouteSpec): ")
    personalised = user_input("Is this a personalised route spec? (Y/n): ", [:verbose])
    platforms = user_input("List the route spec's platforms: ")
    type = user_input("Is this a mock route spec? (Y/n): ", [:verbose])

    %{
      name: Macro.camelize(name),
      platforms: String.split(platforms, [",", " "], trim: true),
      template_type: template_type(personalised),
      file_type: file_type(type)
    }
  end

  defp fill_template(name, platforms, type) do
    {:ok, template} = Solid.parse(type)

    content = Solid.render!(template, %{
        "route_spec" => %{"name" => name, "specs" => fill_platform_template(platforms)}
      })

    {name, to_string(content)}
  end

  defp fill_platform_template(platforms) do
    {:ok, template} = Solid.parse(String.replace(@platform_template, "\n", ""))

    Enum.map_join(platforms, ",\n", fn platform ->
      Solid.render!(template, %{"platform" => %{"name" => platform}})
    end)
  end

  defp generate_file(name, content, type) do
    path_to_file = Path.join(@spec_dirs[type], [Macro.underscore(name), ".ex"])

    cond do
      File.exists?(path_to_file) -> raise "File already exists! Please try another name."
      !File.dir?(path_to_file) -> File.mkdir_p!(Path.dirname(path_to_file))
      true -> true
    end

    File.write!(path_to_file, Code.format_string!(content))
  end

  defp parse_i(i) when i in ["y", "Y", "yes", "Yes", "YES"], do: true
  defp parse_i(i) when i not in ["n", "N", "no", "No", "NO"], do: true
  defp parse_i(_), do: nil

  defp user_input(prompt, opts \\ [])
  defp user_input(prompt, [:verbose]), do: user_input(prompt) |> parse_i()
  defp user_input(prompt, _opts), do: prompt |> IO.gets() |> String.trim()

  defp template_type(true), do: @personalised_route_spec_template
  defp template_type(_), do: @route_spec_template

  defp file_type(true), do: :mock
  defp file_type(_), do: :lib
end
