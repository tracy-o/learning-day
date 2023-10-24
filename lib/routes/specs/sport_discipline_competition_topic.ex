defmodule Routes.Specs.SportDisciplineCompetitionTopic do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        query_params_allowlist: ["page"],
        personalisation: "on",
        examples: ["/sport/football/womens-world-cup", "/sport/football/womens-european-championship", "/sport/football/welsh-premier-league", "/sport/football/us-major-league", "/sport/football/spanish-la-liga", "/sport/football/scottish-premiership", "/sport/football/scottish-league-two", "/sport/football/scottish-league-one", "/sport/football/scottish-league-cup", "/sport/football/scottish-cup", "/sport/football/scottish-championship", "/sport/football/scottish-challenge-cup", "/sport/football/portuguese-primeira-liga", "/sport/football/national-league", "/sport/football/league-two", "/sport/football/league-one", "/sport/football/league-cup", "/sport/football/italian-serie-a", "/sport/football/german-bundesliga", "/sport/football/french-ligue-one", "/sport/football/europa-league", "/sport/football/dutch-eredivisie", "/sport/football/champions-league", "/sport/cricket/the-hundred"]
      }
    }
  end
end
