defmodule Routes.Specs.SportEmbedsTeamSelector do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-news-and-sport-web",
        runbook: "https://confluence.dev.bbc.co.uk/display/sport/BBC+Sport+Team+Selector+%28Webcore%29+Runbook",
        platform: "Webcore",
        query_params_allowlist: ["image"],
        examples: ["/sport/alpha/football/sport-embeds-previews/team-selector/fts1693400043?image=fts1693400043-cbe383b6-b1ee-45fd-87cc-b5195fcbbd0b"]
      }
    }
  end
end
