defmodule Credo.Checks.TestFileSuffix do
  use Credo.Check,
    base_priority: :high,
    category: :consistency,
    run_on_all: true,
    explanations: [
      check: """
      Test files should end with "_test.exs" otherwise they are not run as part of the test suite.
      """
    ]

  @excluded_files ["test/test_helper.exs"] ++ Path.wildcard("test/support/**/*")

  def run(source_file = %SourceFile{}, params) do
    if valid_test_file?(source_file.filename) do
      []
    else
      issue(source_file, params)
    end
  end

  defp valid_test_file?(filename) when filename in @excluded_files, do: true

  defp valid_test_file?("test/" <> rest) do
    String.ends_with?(rest, "_test.exs")
  end

  defp valid_test_file?(_filename), do: true

  defp issue(source_file, params) do
    source_file
    |> IssueMeta.for(params)
    |> format_issue(message: "Filename should end with \"_test.exs\"")
    |> List.wrap()
  end
end
