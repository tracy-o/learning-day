defmodule Belfrage.Smoke.Rules do
  alias Belfrage.Smoke.RuleCollector

  def assert_valid_response(test_properties = %{using: loop_id, smoke_env: smoke_env, target: _target}, resp) do
    RuleCollector.rules_for(loop_id, smoke_env, test_properties)
    |> Enum.map(&run_assertion(&1, resp))
    |> Enum.any?()
  end

  defp run_assertion(checks, resp) when is_list(checks) do
    Enum.all?(checks, &run_assertion(&1, resp))
  end

  defp run_assertion({check_func, expectation}, resp) do
    apply(Belfrage.Smoke.Assertions, check_func, [resp, expectation])
  end

  defp run_assertion(check_func, resp) do
    apply(Belfrage.Smoke.Assertions, check_func, [resp])
  end
end
