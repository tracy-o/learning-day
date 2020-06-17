defmodule Support.Smoke.RuleCollector do
  alias Support.Smoke.RuleLibrary

  @compulsory_assertions [
    :not_a_fallback,
    :correct_stack_id
  ]

  def rules_for(loop_id, smoke_env, test_properties) do
    specs = Belfrage.RouteSpec.specs_for(loop_id, smoke_env)

    specs.pipeline
    |> Enum.reduce([], &get_pipeline_rules(&1, test_properties, &2))
    |> Enum.into(%{})
    |> default()
  end

  defp default(rules) when rules == %{} do
    %{
      "DefaultChecks" => [{:has_status, 200}, {:has_content_length_over, 30}] ++ @compulsory_assertions
    }
  end

  defp default(rules), do: rules

  defp get_pipeline_rules(pipeline, test_properties, acc) do
    case RuleLibrary.rules_for_pipeline(pipeline, test_properties) do
      :no_rules -> acc
      rules -> acc ++ [{pipeline, rules ++ @compulsory_assertions}]
    end
  end
end
