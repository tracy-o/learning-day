defmodule Credo.Checks.RequestTransformerPrefix do
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

  @request_transformer_directory "lib/belfrage/request_transformers"
  @request_transformer_prefix "Belfrage.RequestTransformers."

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

    if in_request_transformer_directory?(filename) and not has_request_transformer_prefix?(module_name) do
      [issue_for(issue_meta, meta[:line], name) | issues]
    else
      issues
    end
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(
      issue_meta,
      message: """
         The RequestTransformer module name does not have the correct prefix. It should have the prefix:
            #{@request_transformer_prefix}
      """,
      trigger: trigger,
      line_no: line_no
    )
  end

  defp in_request_transformer_directory?(filename) do
    Path.dirname(filename) == @request_transformer_directory
  end

  defp has_request_transformer_prefix?(module_name) do
    match?(["Belfrage", "RequestTransformers", _name], String.split(module_name, "."))
  end
end
