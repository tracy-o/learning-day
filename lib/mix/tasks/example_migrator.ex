defmodule Mix.Tasks.ExampleMigrator do
  @moduledoc "Adds examples from routefiles to their respective routespecs"
  use Mix.Task

  @multi_platform_specs [
    "BitesizeArticles",
    "BitesizeTopics",
    "BitesizeTransition",
    "NewsArticleMvt",
    "NewsStorytellingPage"
  ]
  @routes Routes.Routefiles.Main.Test.routes() ++ Routes.Routefiles.Sport.Test.routes()

  def run([]) do
    @routes
    |> Enum.filter(fn {_path, route_map} -> route_map.using not in @multi_platform_specs end)
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

    examples = filter_examples_env(route_maps)
    test_examples = filter_examples_env(route_maps, "test")

    {:ok, original} = File.read(spec_path)
    {:ok, io_device} = File.open(spec_path, [:write])

    updated_spec = update_spec(String.split(original, "\n      }\n    }"), examples, test_examples)

    IO.write(io_device, updated_spec)
    File.close(io_device)
  end

  defp update_spec([head, tail], examples, []) do
    "#{head}," <> "\n        examples: #{inspect(examples, limit: :infinity)}\n      }\n    }" <> tail
  end

  defp update_spec([head, tail], examples, test_examples) do
    head = String.replace(head, "specification do", "specification(production_env) do")

    tail =
      String.replace(
        tail,
        "\nend\n",
        "\n\n  defp examples(\"live\"), do: #{inspect(examples, limit: :infinity)}\n  defp examples(_production_env), do: #{inspect(test_examples, limit: :infinity)}\nend\n"
      )

    "#{head}," <> "\n        examples: examples(production_env)\n      }\n    }" <> tail
  end

  defp format_examples(%{examples: examples}) do
    examples
    |> Enum.map(&format_example/1)
    |> Enum.uniq()
  end

  defp format_examples(_route_map), do: []

  defp format_example(example) when is_binary(example), do: example
  defp format_example({example, status}), do: %{path: example, expected_status: status}

  defp filter_examples_env(examples, env \\ nil) do
    examples
    |> Enum.filter(fn e -> e.only_on == env end)
    |> Enum.map(&format_examples/1)
    |> List.flatten()
  end
end
