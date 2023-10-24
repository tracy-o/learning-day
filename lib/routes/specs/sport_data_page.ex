defmodule Routes.Specs.SportDataPage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/ONEWEB/BBC+Sport+Mozart+Content+Pages+Run+Book",
        platform: "MozartSport",
        examples: ["/sport/rugby-union/match/EVP3551735", "/sport/rugby-union/match/EVP3551735.app", "/sport/rugby-league/match/EVP3489302", "/sport/rugby-league/match/EVP3489302.app", "/sport/cricket/scorecard/ECKO39913", "/sport/cricket/scorecard/ECKO39913.app", "/sport/tennis/order-of-play", "/sport/tennis/order-of-play.app", "/sport/tennis/live-scores", "/sport/tennis/live-scores.app", "/sport/golf/lpga-tour/leaderboard", "/sport/golf/lpga-tour/leaderboard.app", "/sport/golf/leaderboard", "/sport/golf/leaderboard.app", %{expected_status: 302, path: "/sport/cricket/teams/lancashire/averages"}, %{expected_status: 302, path: "/sport/cricket/teams/lancashire/averages.app"}, "/sport/cricket/indian-premier-league/averages", "/sport/cricket/indian-premier-league/averages.app", "/sport/cricket/averages", "/sport/cricket/averages.app", "/sport/rugby-league/super-league/table", "/sport/rugby-league/tables", "/sport/rugby-league/tables.app", "/sport/rugby-league/super-league/scores-fixtures", "/sport/rugby-league/scores-fixtures", "/sport/rugby-league/scores-fixtures.app", "/sport/snooker/results", "/sport/tennis/results", "/sport/snooker/results.app", "/sport/tennis/results.app", "/sport/athletics/british-championship/results", "/sport/ice-hockey/fixtures", "/sport/ice-hockey/fixtures.app", "/sport/ice-hockey/nhl/fixtures", "/sport/winter-sports/calendar.app"]
      }
    }
  end
end
