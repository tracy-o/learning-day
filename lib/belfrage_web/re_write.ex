defmodule BelfrageWeb.ReWrite do
  alias BelfrageWeb.ReWrite

  @var_signs [":", "*"]
  @end_of_var_signs ["/", "-"]

  @doc ~S"""
  Prepares a matcher for use with the interpolate/2 function.

      iex> prepare("/foo/bar-:id/page/:type/*any")
      ["/foo/bar-", {:var, "id"}, "/page/", {:var, "type"}, "/", {:var, "any"}]

      iex> prepare("https://bbc.co.uk/foo/bar-:id/page/:type/*any")
      ["https://bbc.co.uk/foo/bar-", {:var, "id"}, "/page/", {:var, "type"}, "/", {:var, "any"}]

      iex> prepare("bbc.co.uk/foo/bar-:id/page/:type/*any")
      ["bbc.co.uk/foo/bar-", {:var, "id"}, "/page/", {:var, "type"}, "/", {:var, "any"}]

      iex> prepare("/:one-:two-:three")
      ["/", {:var, "one"}, "-", {:var, "two"}, "-", {:var, "three"}]

      iex> prepare("/:one:two:three")
      ["/", {:var, "one"}, {:var, "two"}, {:var, "three"}]
  """
  def prepare(matcher) do
    chunk(matcher)
    |> Enum.map(fn
      [char | rest] when char in @var_signs and length(rest) > 0 -> {:var, Enum.join(rest)}
      chars -> Enum.join(chars, "")
    end)
    |> Enum.chunk_by(&is_binary/1)
    |> Enum.flat_map(fn chunk ->
      case Enum.all?(chunk, &is_binary/1) do
        false -> chunk
        true -> [Enum.join(chunk, "")]
      end
    end)
  end

  defp chunk(matcher) do
    chunk_fun = fn element, acc ->
      if element in @var_signs ++ @end_of_var_signs do
        {:cont, acc, [element]}
      else
        {:cont, acc ++ [element]}
      end
    end

    after_fun = fn acc -> {:cont, acc, []} end

    Enum.chunk_while(String.graphemes(matcher), [], chunk_fun, after_fun)
  end

  @doc ~S"""
  Interpolates path parameters into a string.

      iex> interpolate(prepare("/another-page/:id/a-different-slug"), %{"id" => "12345"})
      "/another-page/12345/a-different-slug"

      iex> interpolate(prepare("/another-page/*any"), %{"any" => ["forward", "slash", "separated"]})
      "/another-page/forward/slash/separated"

      iex> interpolate(prepare("/another-page/something-:id"), %{"id" => "54321", "any" => ["slash", "separated"]})
      "/another-page/something-54321"

      iex> interpolate(prepare("/trailing-slash/"), %{})
      "/trailing-slash"

      iex> interpolate(prepare("/:one:two:three"), %{"one" => "1", "two" => "2", "three" => "3"})
      "/123"
  """
  def interpolate(matcher, params) do
    Enum.map_join(matcher, fn
      {:var, key} -> path_value(Map.fetch!(params, key))
      char -> char
    end)
    |> String.replace_trailing("/", "")
  end

  defp path_value(values) when is_list(values), do: Enum.join(values, "/")
  defp path_value(value), do: value
end
