defmodule Mix.Tasks.ExampleGenerator do
  use Mix.Task

  @moduledoc """
  Example commands:

  passing:
  mix example_generator --pattern "id: c[a-zA-Z0-9]{10}o" --matcher "/afaanoromoo/articles/:id" -n 4
  mix example_generator -m "/programmes/a-z/by/:search/:slice" -p "search: ^[a-zA-Z@]$" -p "slice: ^(all|player)$" -q
  mix example_generator -m "/programmes/a-z/by/:search.json"
  mix example_generator -m "/newsround/av/:id"

  failing:
  mix example_generator --pattern "id: ^c[a-zA-Z0-9]{10}o$"
  mix example_generator --matcher "/newsround/:fake_id"
  mix example_generator --matcher "/newsround"
  """

  # TODO
  # - Generate realistic query strings 🟢
  # - Examples with more than one id + pattern 🟢
  #   ^ Fix repeats 🟢
  # - Ability to search from a routefile. 🟢
  #   ^ Grab the patterns from the handles in routefile 🟢
  #   ^ Ability to take from funs with multiple conditions
  # - Work with routes ending in .<extension> 🟢

  @rf %{"main" => "../belfrage/lib/routes/routefiles/main.ex"}
  @default_args [number: 2, add_q_str: false]
  @strict_args [matcher: :string, pattern: :keep, number: :integer, add_q_str: :boolean, routefile: :string]
  @aliases [m: :matcher, p: :pattern, n: :number, q: :add_q_str, r: :routefile]

  def run(args) do
    {valid_args, _, _} = OptionParser.parse(args, aliases: @aliases, strict: @strict_args)
    opts = parse_args(valid_args)
    generate_examples(opts, opts[:number]) |> inspect() |> IO.puts()
  end

  defp parse_args(args) do
    case {args[:matcher], args[:pattern], args[:routefile]} do
      {m, nil, nil} when not is_nil(m) -> raise(ArgumentError, "Matcher requires a pattern or routefile")
      {_m, _p, r} when not is_nil(r) -> Keyword.merge(@default_args, args ++ [pattern: search_routefile(args[:matcher])])
      _ -> Keyword.merge(@default_args, args)
    end
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

    if opts[:add_q_str], do: example <> generate_query_string(), else: example
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

  defp search_routefile(matcher, path \\ @rf["main"]) do
    {:ok, src} = File.read(path)
    {:ok, {_, _, [_, {_, _, [_, [do: {:__block__, _, routes}]]}]}} = Code.string_to_quoted(src)

    routes
    |> Enum.find(fn {type, _, data} -> {type, List.first(data)} == {:handle, matcher} end)
    |> pattern_from_code()
  end

  defp pattern_from_code(nil), do: raise("Cannot locate route")

  defp pattern_from_code({_, _, [_path, _, [do: {_, _, [[if: {_, _, [{match_fun, _, data}]}]]}]]}) do
    validate_condition(Macro.to_string(match_fun), data)
  end

  defp pattern_from_code(_), do: raise("Cannot locate conditions from matcher")

  defp validate_condition("String . :match?", data) do
    [{id, _, _}, {:sigil_r, _, [{_, _, [pattern]}, _]}] = data
    to_string(id) <> ": " <> pattern
  end
  defp validate_condition("Enum . :member?", data) do
    [list, {id, _, _}] = data
    to_string(id) <> ": ^(" <> Enum.join(list, "|") <> ")$"
  end
  defp validate_condition(_fun, _data), do: nil
end
