defmodule Credo.Checks.RouteSpecFilePath do
  use Credo.Check,
    base_priority: :high,
    param_defaults: [
      ignore: []
    ],
    explanations: [
      check: """
      RouteSpec modules are expected to be in the \"lib/routes/specs\" directory.
      """
    ]

  alias Credo.Code.Name

  @route_spec_directories ["lib/routes/specs", "test/support/mocks/routes/specs"]

  @doc false
  @impl true
  def run(%SourceFile{} = sourcefile, params) do
    issue_meta = IssueMeta.for(sourcefile, params)

    Credo.Code.prewalk(sourcefile, &traverse(&1, &2, issue_meta, sourcefile.filename))
  end

  defp traverse({:defmodule, _meta, arguments} = ast, issues, issue_meta, filename) do
    {ast, issues_for_def(arguments, issues, issue_meta, filename)}
  end

  defp traverse(ast, issues, _issue_meta, _filename) do
    {ast, issues}
  end

  defp issues_for_def(body, issues, issue_meta, filename) do
    case Enum.at(body, 0) do
      {:__aliases__, meta, names} ->
        names
        |> Enum.filter(&String.Chars.impl_for/1)
        |> Enum.join(".")
        |> issues_for_name(meta, issues, issue_meta, filename)

      _ ->
        issues
    end
  end

  defp issues_for_name(name, meta, issues, issue_meta, filename) do
    module_name = Name.full(name)

    if route_spec_module?(module_name) and not in_route_spec_directory?(filename) do
      [issue_for(issue_meta, meta[:line], name) | issues]
    else
      issues
    end
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(
      issue_meta,
      message: ~s(The RouteSpec module is not in one of the directories: #{inspect @route_spec_directories}.),
      trigger: trigger,
      line_no: line_no
    )
  end

  defp in_route_spec_directory?(filename) do
    Path.dirname(filename) in @route_spec_directories
  end

  defp route_spec_module?(module_name) do
    String.starts_with?(module_name, "Routes.Specs")
  end
end
