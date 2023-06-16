defmodule Routes.Specs.BitesizeTipoTopic do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        language_from_cookie: true,
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        query_params_allowlist: ["page"],
        request_pipeline: ["ComToUKRedirect"],
        examples: ["/bitesize/parents", "/bitesize/groups/cz4wkv77g55t"]
      }
    }
  end
end
