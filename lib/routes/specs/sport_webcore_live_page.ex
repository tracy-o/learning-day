defmodule Routes.Specs.SportWebcoreLivePage do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-live",
        runbook: "https://confluence.dev.bbc.co.uk/display/LIVEXP/BBC+Live+Experience+on+Webcore+Run+Book",
        platform: "Webcore",
        query_params_allowlist: ["page", "post"],
        examples: []
      }
    }
  end

  def sports_disciplines_routes do
    [
      "american-football",
      "archery",
      "athletics",
      "badminton",
      "baseball",
      "basketball",
      "bowls",
      "boxing",
      "canoeing",
      "cricket",
      "cycling",
      "darts",
      "disability-sport",
      "diving",
      "equestrian",
      "fencing",
      "formula1",
      "golf",
      "gymnastics",
      "handball",
      "hockey",
      "horse-racing",
      "ice-hockey",
      "judo",
      "karate",
      "mixed-martial-arts",
      "modern-pentathlon",
      "motorsport",
      "netball",
      "rowing",
      "rugby-league",
      "rugby-union",
      "sailing",
      "shooting",
      "skateboarding",
      "snooker",
      "sport-climbing",
      "squash",
      "surfing",
      "swimming",
      "table-tennis",
      "taekwondo",
      "tennis",
      "triathlon",
      "volleyball",
      "water-polo",
      "weightlifting",
      "winter-sports",
      "wrestling"
    ]
  end
end
