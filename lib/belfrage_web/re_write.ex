defmodule BelfrageWeb.ReWrite do
  alias BelfrageWeb.ReWrite

  def prepare(matcher) when is_list(matcher), do: {matcher, %URI{}, ""}
  def prepare(matcher) when is_binary(matcher) do
    uri = URI.parse(matcher)

    {String.split(String.replace_prefix(uri.path, "/", ""), "/"), uri, "/"}
  end

  @doc ~S"""
  Interpolates path parameters into a string.

      iex> interpolate(prepare("/another-page/:id/a-different-slug"), %{"id" => "12345"})
      "/another-page/12345/a-different-slug"

      iex> interpolate(prepare("/another-page/*any"), %{"any" => ["forward", "slash", "separated"]})
      "/another-page/forward/slash/separated"

      iex> interpolate(prepare(["/another-page/something-", ":id"]), %{"id" => "54321", "any" => ["slash", "separated"]})
      "/another-page/something-54321"

      iex> interpolate(prepare(["/another-page/"]), %{})
      "/another-page"
  """

  def interpolate({to, uri, joiner}, params) do
    do_interpolation(to, params, "", joiner)
    |> finalise(uri)
  end

  defp do_interpolation([], _params, return, _joiner), do: return

  defp do_interpolation([":" <> key | rest], params, return, joiner) do
    do_interpolation(rest, params, return <> "#{joiner}#{Map.fetch!(params, key)}", joiner)
  end

  defp do_interpolation(["*" <> key | rest], params, return, joiner) do
    do_interpolation(rest, params, return <> "#{joiner}#{Enum.join(Map.fetch!(params, key), "/")}", joiner)
  end

  defp do_interpolation([value | rest], params, return, joiner) do
    do_interpolation(rest, params, return <> "#{joiner}#{value}", joiner)
  end

  defp finalise(result, uri) do
    %URI{uri | path: result} |> URI.to_string() |> String.trim_trailing("/")
  end
end
