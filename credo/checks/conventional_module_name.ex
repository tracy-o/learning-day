defmodule Credo.Checks.ConventionalModuleName do
  use Credo.Check,
  base_priority: :high,
  # category: :consistency,
  param_defaults: [
    ignore: []
  ]

  # 1. Check if all routespecs file names match the convention for module naming
  #   and have the module name match the file patch
  # 2. Check for duplicate file names?
  alias Credo.Code.Name

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

    if !is_conventional?(filename, module_name) do
      [issue_for(issue_meta, meta[:line], name) | issues]
    else
      issues
    end
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(
      issue_meta,
      message: "This RouteSpec module has already been defined: #{trigger}.",
      trigger: trigger,
      line_no: line_no
    )
  end

  defp is_conventional?(filename, module_name) do
    filename
    |> module_name_from_file()
    |> String.replace(["Lib.", "Test.Support.Mocks."], "")
    |> Kernel.==(module_name)
  end

  defp module_name_from_file(filename) do
    {basename, dir_list} =
      filename
      |> String.split("/")
      |> Enum.map(&String.capitalize/1)
      |> List.pop_at(-1)

    module_name =
      basename
      |> String.replace_trailing(".ex", "")
      |> String.split("_")
      |> Enum.map_join(&String.capitalize/1)

    Enum.join(dir_list ++ [module_name], ".")
  end
end
