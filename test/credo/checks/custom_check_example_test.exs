defmodule Credo.Checks.CustomCheckExampleTest do
  use Credo.Test.Case
  alias Credo.Checks.CustomCheckExample

  test "it should not raise issues" do
    """
    defmodule TestModule do
      import Belfrage.Test.Support.Helper, only: [example_helper: 0]
    end
    """
    |> to_source_file()
    |> run_check(CustomCheckExample)
    |> refute_issues()
  end

  test "it should report a violation" do
    """
    defmodule TestModule do
      import Belfrage.Test.Support.Helper
    end
    """
    |> to_source_file()
    |> run_check(CustomCheckExample)
    |> assert_issue()
  end
end
