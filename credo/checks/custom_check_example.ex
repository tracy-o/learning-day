defmodule Credo.Checks.CustomCheckExample do
  @moduledoc false
  use Credo.Check,
    base_priority: :normal,
    explanations: [
      check: """
      Using bare import statements, without specifying what we are
      importing makes it hard to reason about from where the function
      comes from
      """
    ]

  @impl true
  def run(source_file, params) do
    source_file
    |> Credo.Code.prewalk(&traverse(&1, &2, IssueMeta.for(source_file, params)))
  end

  defp traverse(ast, issues, issue_meta), do: {ast, add_issue(issues, issue(ast, issue_meta))}

  defp add_issue(issues, nil), do: issues
  defp add_issue(issues, issue), do: [issue | issues]

  defp issue({:import, meta, [{:__aliases__, _, _}]}, issue_meta) do
    issue_for(issue_meta, meta[:line])
  end

  defp issue({:import, meta, [{:__aliases__, _, _}, opts]}, issue_meta) do
    if Keyword.has_key?(opts, :only), do: nil, else: issue_for(issue_meta, meta[:line])
  end

  defp issue(_, _), do: nil

  defp issue_for(issue_meta, line_no) do
    format_issue(
      issue_meta,
      message: "Use :only with import statements",
      line_no: line_no
    )
  end
end
