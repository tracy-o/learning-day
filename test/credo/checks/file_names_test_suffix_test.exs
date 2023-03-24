defmodule Credo.Checks.FileNamesTestSuffixTest do
  use Credo.Test.Case

  alias Credo.Check.FileNamesTestSuffix

  test "it should NOT report non-test files" do
    """
    defmodule CredoSampleModule do
      @somedoc "This is somedoc"
    end
    """
    |> to_source_file("lib/credo_sample_module.ex")
    |> run_check(FileNamesTestSuffix)
    |> refute_issues()
  end

  test "it should NOT report correctly named test files" do
    """
    defmodule CredoSampleModuleTest do
      @checkdoc "This is checkdoc"
    end
    """
    |> to_source_file("test/credo_sample_module_test.exs")
    |> run_check(FileNamesTestSuffix)
    |> refute_issues()
  end

  test "it should report incorrectly named test files" do
    """
    defmodule CredoSampleModuleTest do
      @checkdoc "This is checkdoc"
    end
    """
    |> to_source_file("test/credo_sample_module.exs")
    |> run_check(FileNamesTestSuffix)
    |> assert_issue()
  end
end
