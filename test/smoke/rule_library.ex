defmodule Belfrage.Smoke.RuleLibrary do
  def rules_for_pipeline("WorldServiceRedirect", %{tld: ".co.uk"}) do
    [
      {:has_status, 302},
      {:redirects_to, ".com"}
    ]
  end

  def rules_for_pipeline(_transformer, _test_properties), do: :no_rules
end
