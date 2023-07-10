defmodule Routes.Specs.NewsTopics do
  def specification(production_env) do
    %{
      preflight_pipeline: ["BBCXWebcorePlatformSelector"],
      specs: [
        %{
          owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
          platform: "Webcore",
          query_params_allowlist: query_params_allowlist(production_env),
          request_pipeline: ["NewsTopicsPlatformDiscriminator"],
          personalisation: "test_only",
          examples: ["/news/topics/cljev4jz3pjt", %{expected_status: 301, path: "/news/topics/66535a45-8563-4598-be75-851e8e3cb9a9"}, "/news/topics/c207p54mljpt/aberdeenshire-council", %{expected_status: 301, path: "/news/topics/66535a45-8563-4598-be75-851e8e3cb9a9/aberdeenshire-council"}]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end

  defp query_params_allowlist("live"), do: ["page", "market"]

  # allows both Mozart and Webcore query string params
  defp query_params_allowlist(_production_env) do
    query_params_allowlist("live") ++
      ["ads-debug", "component_env", "country", "edition", "mode", "morph_env", "prominence", "renderer_env", "use_fixture"]
  end
end
