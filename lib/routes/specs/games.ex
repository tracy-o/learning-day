defmodule Routes.Specs.Games do
  def specs do
    %{
      owner: "#games-team",
      runbook: "https://confluence.dev.bbc.co.uk/display/CE/CAGE+Games+Runbook",
      platform: "Webcore",
      request_pipeline: ["GamesInternationalRedirect"],
      query_params_allowlist: ["exitGameUrl", "v", "token"]
    }
  end
end
