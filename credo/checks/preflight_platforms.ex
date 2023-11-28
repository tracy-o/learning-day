defmodule Credo.Checks.PreflightPlatforms do
  use Credo.Check,
    base_priority: :normal,
    explanations: [
      check: """
      Setting a platform that doesn't exist in "lib/routes/platforms"
      in the preflight transformer call/1 function will cause issues down the line.
      """
    ]

  @platforms_dir "lib/routes/platforms"

  @impl true
  def run(%SourceFile{} = source_file, params) do
    Credo.Code.prewalk(source_file, &traverse(&1, &2, IssueMeta.for(source_file, params)))
  end

  defp traverse(ast, issues, issue_meta), do: {ast, add_issue(issues, issue(ast, issue_meta))}

  defp add_issue(issues, nil), do: issues
  defp add_issue(issues, issue), do: [issue | issues]

  # platform set by function
  defp issue({:%{}, meta, [platform: fun_name]}, issue_meta) when is_atom(fun_name) do
    issue_for_function(fun_name, meta, issue_meta)
  end

  # platform explicitly set in Envelope.add/3
  defp issue({:%{}, meta, [platform: platform_name]}, issue_meta) when is_binary(platform_name) do
    if !platform_exists?(platform_name) do
      issue_for(issue_meta, meta[:line])
    end
  end

  defp issue(_, _), do: nil

  defp issue_for_function(_fun_name, _meta, _issue_meta) do
    nil
  end

  defp issue_for(issue_meta, line_no) do
    format_issue(
      issue_meta,
      message: "The platform assigned does not seem to exist. Valid platforms are defined in #{@platforms_dir}",
      line_no: line_no
    )
  end

  defp platform_exists?(platform_name) do
    platform_file_name = Macro.underscore(platform_name) <> ".ex"
    File.exists?(@platforms_dir <> "/" <> platform_file_name)
  end
end
