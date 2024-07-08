defmodule Mix.Tasks.GitCli do
  @moduledoc "Git CLI commands and integration"
  use Mix.Task

  @repo Git.new
  # @strict [diff: :string]

  def run([fun | args]) do
    fun = String.to_atom(fun)
    op(fun, parse_args(fun, args))
    |> scope_search()
  end

  defp parse_args(:diff, args) do
    [commits] = args
    String.split(commits, ",", trim: true)
  end

  defp op(:diff, [commitA, commitB]) do
    {:ok, output} = Git.diff(@repo, "#{commitA}...#{commitB}")
    output
  end

  defp scope_search(diff) do
    if Enum.any?(routes_for_stack(:sally), fn route ->
      diff =~ "/" <> route
    end) do
      :sally
    end
  end

  defp routes_for_stack(:sally) do
    Enum.flat_map(scopes(), fn {k, v} ->
      if v == "WorldService", do: [k], else: []
    end)
  end

  defp scopes do
    %{
      "swahili" => "WorldService",
      "portuguese" => "WorldService",
      "korean" => "WorldService",
      "kyrgyz" => "WorldService",
      "ukrainian" => "WorldService",
      "zhongwen" => "WorldService",
      "marathi" => "WorldService",
      "newsbeat" => "News",
      "yoruba" => "WorldService",
      "tigrinya" => "WorldService",
      "amharic" => "WorldService",
      "bengali" => "WorldService",
      "japanese" => "WorldService",
      "arabic" => "WorldService",
      "news" => "News",
      "ukchina" => "WorldService",
      "naidheachdan" => "News",
      "democratiaethfyw" => "News",
      "somali" => "WorldService",
      "nepali" => "WorldService",
      "hindi" => "WorldService",
      "cymrufyw" => "News",
      "russian" => "WorldService",
      "sport" => "Sport",
      "igbo" => "WorldService",
      "worldservice" => "WorldService",
      "punjabi" => "WorldService",
      "afrique" => "WorldService",
      "pidgin" => "WorldService",
      "tamil" => "WorldService",
      "vietnamese" => "WorldService",
      "mundo" => "WorldService",
      "uzbek" => "WorldService",
      "gujarati" => "WorldService",
      "ws" => "WorldService",
      "hausa" => "WorldService",
      "burmese" => "WorldService",
      "thai" => "WorldService",
      "persian" => "WorldService",
      "gahuza" => "WorldService",
      "newyddion" => "News",
      "turkce" => "WorldService",
      "russia" => "WorldService",
      "urdu" => "WorldService",
      "sinhala" => "WorldService",
      "telugu" => "WorldService",
      "afaanoromoo" => "WorldService",
      "indonesia" => "WorldService",
      "pashto" => "WorldService",
      "azeri" => "WorldService",
      "serbian" => "WorldService",
      "tajik" => "WorldService"
    }
  end
end
