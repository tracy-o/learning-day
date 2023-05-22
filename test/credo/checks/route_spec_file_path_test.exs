defmodule Credo.Checks.RouteSpecFilePathTest do
  use Credo.Test.Case

  alias Credo.Checks.RouteSpecFilePath

  test ~s(it should NOT report RouteSpec modules in "lib/routes/specs") do
    """
    defmodule Routes.Specs.SomeTestRouteSpec do
    @somedoc "This is somedoc"
    end
    """
    |> to_source_file("lib/routes/specs/some_test_route_spec.ex")
    |> run_check(RouteSpecFilePath)
    |> refute_issues()
  end

  test ~s(it should NOT report RouteSpec modules in "test/support/mocks/routes/specs") do
    """
    defmodule Routes.Specs.SomeTestRouteSpec do
    @somedoc "This is somedoc"
    end
    """
    |> to_source_file("test/support/mocks/routes/specs/some_test_route_spec.ex")
    |> run_check(RouteSpecFilePath)
    |> refute_issues()
  end

  test ~s(it should NOT report non-RouteSpec modules in "lib/routes/specs") do
    """
    defmodule SomeTestRouteSpec do
    @somedoc "This is somedoc"
    end
    """
    |> to_source_file("lib/routes/specs/some_test_route_spec.ex")
    |> run_check(RouteSpecFilePath)
    |> refute_issues()
  end

  test ~s(it should NOT report non-RouteSpec modules in "test/support/mocks/routes/specs") do
    """
    defmodule SomeTestRouteSpec do
    @somedoc "This is somedoc"
    end
    """
    |> to_source_file("test/support/mocks/routes/specs/some_test_route_spec.ex")
    |> run_check(RouteSpecFilePath)
    |> refute_issues()
  end

  test ~s(it should NOT report non-RouteSpec modules not in ["lib/routes/specs", "test/support/mocks/routes/specs"]) do
    """
    defmodule SomeTestRouteSpec do
    @somedoc "This is somedoc"
    end
    """
    |> to_source_file("lib/routes/some_test_route_spec.ex")
    |> run_check(RouteSpecFilePath)
    |> refute_issues()
  end

  test ~s(it should report RouteSpec modules not in ["lib/routes/specs", "test/support/mocks/routes/specs"]) do
    """
    defmodule Routes.Specs.SomeTestRouteSpec do
    @somedoc "This is somedoc"
    end
    """
    |> to_source_file("lib/routes/some_test_route_spec.ex")
    |> run_check(RouteSpecFilePath)
    |> assert_issue()
  end
end
