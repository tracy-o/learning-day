defmodule BelfrageWeb.ReWrite do
  alias BelfrageWeb.ReWrite

  @doc ~S"""
  Prepares a matcher for use with the interpolate/2 function.

      iex> prepare("/foo/bar-:id/page/:type/*any")
      ["/foo/bar-", {:var, "id"}, "/page/", {:var, "type"}, "/", {:var, "any"}]

      # iex> prepare("https://bbc.co.uk/foo/bar-:id/page/:type/*any")
      # ["https://bbc.co.uk/foo/bar-", {:var, "id"}, "/page/", {:var, ":type"}, {:var, "any"}]
  """

  @var_signs [":", "*"]
  @end_of_var_signs ["/", "-"]

  def prepare(matcher) do
    chunk(matcher)
    |> Enum.map(fn
      [char | rest] when char in @var_signs -> {:var, Enum.join(rest)}
      chars -> Enum.join(chars, "")
    end)
    |> Enum.chunk_by(&is_binary/1)
    |> Enum.map(fn chunk ->
      case Enum.all?(chunk, &is_binary/1) do
        true -> Enum.join(chunk, "")
        false -> Enum.at(chunk, 0)
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

    after_fun = fn
      # [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end

      Enum.chunk_while(String.graphemes(matcher), [], chunk_fun, after_fun)
  end
end
