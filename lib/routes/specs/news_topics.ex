defmodule Routes.Specs.NewsTopics do
  def specification(production_env) do
    %{
      specs: %{
        owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        query_params_allowlist: query_params_allowlist(production_env),
        request_pipeline: ["NewsTopicsPlatformDiscriminator"],
        personalisation: "test_only"
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
