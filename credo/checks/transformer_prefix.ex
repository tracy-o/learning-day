defmodule Credo.Checks.TransformerModulePrefix do
  use Credo.Check,
    base_priority: :high,
    param_defaults: [
      ignore: []
    ]

  alias Credo.Code.Name

  @transformer_types [:preflight, :request, :response]

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

    @transformer_types
    |> Enum.flat_map(fn type ->
      if in_transformer_directory?(filename, type) and not has_transformer_prefix?(module_name, type) do
        [issue_for(issue_meta, meta[:line], name, type) | issues]
      else
        issues
      end
    end)
  end

  defp issue_for(issue_meta, line_no, trigger, type) do
    format_issue(
      issue_meta,
      message: """
      The Transformer module name does not have the correct prefix. It should have the prefix:
            #{transformer_prefix(type)}
      """,
      trigger: trigger,
      line_no: line_no
    )
  end

  defp in_transformer_directory?(filename, type) do
    Path.dirname(filename) == transformer_directory(type)
  end

  defp has_transformer_prefix?(module_name, type) do
    case type do
      :preflight ->
        match?(["Belfrage", "PreflightTransformers", _name], String.split(module_name, "."))

      :request ->
        match?(["Belfrage", "RequestTransformers", _name], String.split(module_name, "."))

      :response ->
        match?(["Belfrage", "ResponseTransformers", _name], String.split(module_name, "."))
    end
  end

  defp transformer_directory(type) do
    case type do
      :preflight ->
        "lib/belfrage/preflight_transformers"

      :request ->
        "lib/belfrage/request_transformers"

      :response ->
        "lib/belfrage/response_transformers"
    end
  end

  defp transformer_prefix(type) do
    case type do
      :preflight ->
        "Belfrage.PreflightTransformers."

      :request ->
        "Belfrage.RequestTransformers."

      :response ->
        "Belfrage.ResponseTransformers."
    end
  end
end
