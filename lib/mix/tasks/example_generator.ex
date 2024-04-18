defmodule Mix.Tasks.ExampleGenerator do
  use Mix.Task

  @moduledoc """
  Generate random example routes based on patterns and matchers.
  """

  @doc """
  Args:
  [-p, --pattern]     specify the regex pattern for the key in the matcher. i.e "id: c[a-zA-Z0-9]{10}o" for matcher "/some/path/:id"
  [-m, --matcher]     the structure of the path to be used as the matcher i.e -m "/some/path/:id"
  [-n, --number]      the number of results to return
  [-q, --with-query]  append a random query string to each result

  Example commands:
  passing:
  mix example_generator --pattern "id: c[a-zA-Z0-9]{10}o" --matcher "/afaanoromoo/articles/:id" -n 4
  mix example_generator -m "/programmes/a-z/by/:search/:slice" -p "search: ^[a-zA-Z@]$" -p "slice: ^(all|player)$" -q

  expected fail:
  mix example_generator -m "/programmes/a-z/by/:search.json"
  mix example_generator -m "/newsround/av/:id"
  mix example_generator --matcher "/newsround"
  mix example_generator --pattern "id: ^c[a-zA-Z0-9]{10}o$"

  failing:
  """

  # TODO
  # - Generate realistic query strings 🟢
  # - Examples with more than one id + pattern 🟢
  #   ^ Fix repeats 🟢
  # - Ability to search from a routefile. 🟢
  #   ^ Grab the patterns from the handles in routefile 🟢
  #   ^ Identify BelfrageWeb.Validators funcs
  #   ^ Ability to take from funcs with multiple conditions
  # - Work with routes ending in .<extension> 🟢

  @default_args [number: 2, with_query: false]
  @strict_args [matcher: :string, pattern: :keep, number: :integer, with_query: :boolean, routefile: :string]
  @aliases [m: :matcher, p: :pattern, n: :number, q: :with_query, r: :routefile]
  @routefiles %{
    "main" => "lib/routes/routefiles/main.ex",
    "sport" => "lib/routes/routefiles/sport.ex",
    "mock" => "lib/routes/routefiles/mock.ex",
    "world service" => "lib/routes/routefiles/world_service.ex",
    "news" => "lib/routes/routefiles/news.ex"
  }

  def run(args) do
    {valid_args, _, _} = OptionParser.parse(args, aliases: @aliases, strict: @strict_args)
    parse_args(valid_args)
  end

  defp parse_args(args) do
    case validate_args(args[:matcher], args[:pattern], args[:routefile]) do
      {:error, "Invalid"} ->
        IO.puts("some help message")

      {:error, reason} ->
        raise reason

      {:ok, new_args} ->
        opts = Keyword.merge(@default_args, args ++ new_args) |> IO.inspect(label: "parsed args")
        generate_examples(opts, opts[:number]) |> inspect() |> IO.puts()
    end
  end

  defp validate_args(nil, nil, nil), do: {:error, "Invalid"}
  defp validate_args(_matcher, nil, nil), do: {:error, "Matcher requires a pattern or routefile"}
  defp validate_args(nil, _pattern, _routefile), do: {:error, "No matcher for pattern"}
  defp validate_args(_matcher, pattern, _routefile) when is_binary(pattern), do: {:ok, []}

  defp validate_args(matcher, _pattern, routefile) when is_binary(routefile) do
    {:ok, [pattern: search_routefile(matcher, routefile)]}
  end

  defp generate_examples(opts, max, result \\ [])

  defp generate_examples(opts, max, result) when length(result) < max do
    result = Enum.uniq(result ++ [generate_example(opts)])
    generate_examples(opts, max, result)
  end

  defp generate_examples(_, _, result), do: result

  defp generate_example(opts) do
    random_ids = generate_random_id(Keyword.get_values(opts, :pattern))

    example =
      opts[:matcher]
      |> String.split("/")
      |> Enum.map_join("/", fn section ->
        split = String.split(section, ".")

        if length(split) > 1 do
          [section] = Map.get(random_ids, List.first(split)) || section
          section <> "." <> List.last(split)
        else
          Map.get(random_ids, section) || section
        end
      end)

    if opts[:with_query], do: example <> generate_query_string(), else: example
  end

  defp generate_random_id(patterns) do
    patterns
    |> Enum.flat_map(fn key_pattern ->
      [key, pattern] = String.split(key_pattern, ": ", global: false)
      {:ok, rgx} = Regex.compile(pattern)
      %{(":" <> key) => regex_to_string(rgx)}
    end)
    |> Map.new()
  end

  defp regex_to_string(rgx, num \\ 1), do: Randex.stream(rgx) |> Enum.take(num)

  defp generate_query_string() do
    regex_to_string(~r/\?(page|search|q)=[a-zA-Z0-9]{8}/) |> List.first()
  end

  defp search_routefile(matcher, routefile) do
    {:ok, src} = File.read(@routefiles[routefile])
    {:ok, {_, _, [_, {_, _, [_, [do: {:__block__, _, routes}]]}]}} = Code.string_to_quoted(src)

    routes
    |> Enum.find(fn {type, _, data} -> {type, List.first(data)} == {:handle, matcher} end)
    |> pattern_from_code()
  end

  defp pattern_from_code(nil), do: raise("Cannot locate route")

  defp pattern_from_code({_, _, [_path, _, [do: {_, _, [[if: {_, _, [{match_fun, _, data}]}]]}]]}) do
    validate_condition(Macro.to_string(match_fun), data)
  end

  defp validate_condition("String . :match?", data) do
    [{id, _, _}, {:sigil_r, _, [{_, _, [pattern]}, _]}] = data
    to_string(id) <> ": " <> pattern
  end

  defp validate_condition("Enum . :member?", data) do
    [list, {id, _, _}] = data
    to_string(id) <> ": ^(" <> Enum.join(list, "|") <> ")$"
  end

  defp validate_condition(_, _), do: raise("Cannot locate conditions from matcher")
end
