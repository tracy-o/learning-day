defmodule Credo.Check.FileNamesTestSuffix do
  use Credo.Check,
    base_priority: :high,
    category: :consistency,
    run_on_all: true,
    explanations: [
      check: """
      Test files should end with "_test.exs" otherwise they are not run as part of the test suite.
      """
    ]

  @excluded_files ["test/test_helper.exs"]

  def run(source_file = %SourceFile{}, params) do
    if should_be_validated?(source_file.filename) do
      if String.ends_with?(source_file.filename, "_test.exs") do
        []
      else
        source_file
        |> IssueMeta.for(params)
        |> format_issue(message: "Filename should end with \"_test.exs\"")
        |> List.wrap()
      end
    else
      []
    end
  end

  defp should_be_validated?(filename) do
    String.starts_with?(filename, "test/") &&
      not String.starts_with?(filename, "test/support/") &&
      not Enum.member?(@excluded_files, filename)
  end
end
