defmodule Routes.Specs.NewsBusinessTopics do
  def specification(production_env) do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        query_params_allowlist: query_params_allowlist(production_env),
        personalisation: "test_only",
        examples: ["/news/business/topics/cem601g08pkt"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["page", "market"]

  # allows both Mozart and Webcore query string params
  defp query_params_allowlist(_production_env) do
    query_params_allowlist("live") ++
      ["ads-debug", "component_env", "country", "edition", "mode", "morph_env", "prominence", "renderer_env", "use_fixture"]
  end
end
