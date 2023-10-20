defmodule ExampleModifier do
  use Mix.Task

  @moduledoc "Filter and modify examples from routespecs based on a keyword found in the example"

  def run([]) do
    for {spec_name, examples} <- filter_specs() do
      replace_examples(spec_name, examples)
    end
  end

  defp spec_src(spec_name) do
    module = Module.concat([Routes, Specs, spec_name])
    module.__info__(:compile)[:source]
  end

  # Belfrage.RouteSpec.list_examples() for examples
  defp filter_specs(examples, keyword \\ "rss.xml") do
    examples
    |> Enum.filter(&String.contains?(&1.path, keyword))
    |> Enum.group_by(fn example -> example.spec end)
  end

  defp replace_examples(spec_name, examples) do
    spec_path = spec_src(spec_name)
    examples = Enum.map(examples, &maybe_update_example/1)

    {:ok, original} = File.read(spec_path)
    {:ok, io_device} = File.open(spec_path, [:write])

    updated_spec = String.replace(original, ~r/examples: \[.+\]/, "examples: #{inspect(examples, limit: :infinity)}")

    IO.write(io_device, updated_spec)
    File.close(io_device)
  end

  defp maybe_update_example(example = %{path: path}) do
    e = if String.ends_with?(path, "/rss.xml"), do: update_header(example), else: example
    parse_example(e)
  end

  defp update_header(example = %{headers: %{}}) do
    Map.put(example, :headers, %{"host" => "feeds.bbci.co.uk"})
  end

  defp update_header(example  = %{headers: headers}) do
    Map.put(example, :headers, Map.put(headers, "host", "feeds.bbci.co.uk"))
  end

  defp parse_example(%{headers: headers, path: path, expected_status: 200}) do
    %{headers: headers, path: path}
  end

  defp parse_example(%{headers: headers, path: path, expected_status: status}) do
    %{expected_status: status, headers: headers, path: path}
  end
end
