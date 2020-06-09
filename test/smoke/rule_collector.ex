defmodule Belfrage.Smoke.RuleCollector do
  alias Belfrage.Smoke.RuleLibrary

  def rules_for(loop_id, smoke_env, test_properties) do
    specs = Belfrage.RouteSpec.specs_for(loop_id, smoke_env)

    specs.pipeline
    |> Enum.map(&RuleLibrary.rules_for_pipeline(&1, test_properties))
    |> base_rules()
    |> IO.inspect(label: "rules")
  end

  defp base_rules(rules) do
    case List.flatten(rules) do
      [] -> [{:has_status, 200}, {:has_content_length_over, 30}]
      _flat_rules -> rules
    end
  end
end
