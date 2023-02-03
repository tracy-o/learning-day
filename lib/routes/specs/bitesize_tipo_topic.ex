defmodule Routes.Specs.BitesizeTipoTopic do
  def specs do
    %{
      owner: "childrensfutureweb@bbc.co.uk",
      platform: "Webcore",
      language_from_cookie: true,
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      query_params_allowlist: ["page"],
      request_pipeline: ["ComToUKRedirect"]
    }
  end
end
