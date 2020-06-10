defmodule Belfrage.Smoke.RuleCollector do
  alias Belfrage.Smoke.RuleLibrary

  @compulsory_rules [
    :not_a_fallback
  ]

  def rules_for(loop_id, smoke_env, test_properties) do
    specs = Belfrage.RouteSpec.specs_for(loop_id, smoke_env)

    specs.pipeline
    |> Enum.map(&rule_from_library(&1, test_properties))
    |> default()
  end

  defp default(rules) do
    case List.flatten(rules) do
      [] -> [{:has_status, 200}, {:has_content_length_over, 30}]
      _flat_rules -> rules
    end
  end

  defp rule_from_library(pipeline, test_properties) do
    RuleLibrary.rules_for_pipeline(pipeline, test_properties) ++ @compulsory_rules
  end
end
