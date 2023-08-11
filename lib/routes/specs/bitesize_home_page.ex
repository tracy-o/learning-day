defmodule Routes.Specs.BitesizeHomePage do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
        platform: "Webcore",
        request_pipeline: ["ComToUKRedirect"],
        language_from_cookie: true,
        query_params_allowlist: ["page"],
        examples: ["/bitesize"]
      }
    }
  end
end
