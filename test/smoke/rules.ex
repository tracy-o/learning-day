defmodule Belfrage.Smoke.Rules do
  alias Belfrage.Smoke.RuleCollector

  def run_assertions(test_properties = %{using: loop_id, smoke_env: smoke_env, target: _target}, resp) do
    RuleCollector.rules_for(loop_id, smoke_env, test_properties)
    |> Enum.map(fn {pipeline_name, rules} ->
      {pipeline_name, run_assertion(rules, resp, test_properties)}
    end)
    |> Enum.into(%{})
  end

  def passed?(results) when is_map(results) do
    results
    |> Enum.any?(fn {_pipeline, result} -> passed?(result) end)
  end

  def passed?(results) when is_list(results) do
    Enum.all?(results, fn
      :ok -> true
      _failures -> false
    end)
  end

  def format_failures(results) do
    Enum.map_join(results, fn
      {pipeline, failures} ->
        failures = Enum.filter(failures, fn failure -> failure != :ok end)

        "Rules for #{pipeline} failed:\n#{Enum.join(failures, "\n\nw")}"
    end)
  end

  defp run_assertion(checks, resp, test_properties) when is_list(checks) do
    Enum.map(checks, &run_assertion(&1, resp, test_properties))
  end

  defp run_assertion({check_func, expectation}, resp, test_properties) do
    apply(Belfrage.Smoke.Assertions, check_func, [resp, expectation, test_properties])
  end

  defp run_assertion(check_func, resp, test_properties) do
    apply(Belfrage.Smoke.Assertions, check_func, [resp, test_properties])
  end
end
