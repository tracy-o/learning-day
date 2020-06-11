defmodule Support.Smoke.RuleCollectorTest do
  use ExUnit.Case
  alias Support.Smoke.RuleCollector

  describe "collects smoke test rules" do
    test "when loop has a pipeline, which has specific rules" do
      test_properties = %{tld: ".co.uk"}
      smoke_env = "test"
      loop_id = "SomeWorldServiceLoop"

      assert %{
               "WorldServiceRedirect" => [
                 {:has_status, 302},
                 {:redirects_to, ".com"},
                 :not_a_fallback,
                 :correct_stack_id
               ]
             } = RuleCollector.rules_for(loop_id, smoke_env, test_properties)
    end

    test "when loop has a pipeline, which does not have specific rules" do
      test_properties = %{}
      smoke_env = "test"
      loop_id = "SomeLoop"

      assert %{
               "DefaultChecks" => [
                 {:has_status, 200},
                 {:has_content_length_over, 30},
                 :not_a_fallback,
                 :correct_stack_id
               ]
             } == RuleCollector.rules_for(loop_id, smoke_env, test_properties)
    end
  end
end
