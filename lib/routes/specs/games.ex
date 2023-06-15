defmodule Routes.Specs.Games do
  def specification do
    %{
      specs: %{
        owner: "#games-team",
        runbook: "https://confluence.dev.bbc.co.uk/display/CE/CAGE+Games+Runbook",
        platform: "Webcore",
        request_pipeline: ["GamesInternationalRedirect"],
        query_params_allowlist: ["exitGameUrl", "v", "token"],
        examples: ["/games/embed/genie-starter-pack"]
      }
    }
  end
end
