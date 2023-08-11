defmodule Mix.Tasks.ExampleMigrator do
  @moduledoc "Adds examples from routefiles to their respective routespecs"
  use Mix.Task

  # This script migrates single-platform specs only to make the script simple
  @multi_platform_specs [
    "BitesizeArticles",
    "BitesizeGuides",
    "BitesizeTopics",
    "BitesizeTransition",
    "NewsArticleMvt",
    "NewsStorytellingPage"
  ]
  @routes Routes.Routefiles.Main.Test.routes() ++ Routes.Routefiles.Sport.Test.routes()

  def run([]) do
    @routes
    |> Enum.filter(fn {_path, route_map} ->
      route_map.using not in @multi_platform_specs and route_map.only_on != "test"
    end)
    |> Enum.map(fn {_path, route_map} -> route_map end)
    |> Enum.group_by(&Map.get(&1, :using))
    |> Enum.each(fn {spec_name, route_maps} -> write_tests(spec_name, route_maps) end)
  end

  defp spec_src(spec_name) do
    module = Module.concat([Routes, Specs, spec_name])
    module.__info__(:compile)[:source]
  end

  defp write_tests(spec_name, route_maps) do
    spec_path = spec_src(spec_name)

    examples =
      route_maps
      |> Enum.map(&format_examples/1)
      |> List.flatten()

    {:ok, original} = File.read(spec_path)
    {:ok, io_device} = File.open(spec_path, [:write])

    [head, tail] = String.split(original, "\n      }\n    }")
    updated_spec = head <> ",\n        examples: #{inspect(examples, limit: :infinity)}\n      }\n    }" <> tail

    IO.write(io_device, updated_spec)
    File.close(io_device)
  end

  defp format_examples(%{examples: examples}) do
    examples
    |> Enum.map(&format_example/1)
    |> Enum.uniq()
  end

  defp format_examples(_route_map), do: []

  defp format_example(example) when is_binary(example), do: example
  defp format_example({example, status}), do: %{path: example, expected_status: status}
end
