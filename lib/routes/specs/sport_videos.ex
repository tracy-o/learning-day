defmodule Routes.Specs.SportVideos do
  def specification(production_env) do
    %{
      specs: %{
        owner: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        query_params_allowlist: query_params_allowlist(production_env),
        examples: ["/sport/av/football/55975423", "/sport/av/formula1/55303534", "/sport/av/rugby-league/56462310", "/sport/av/51107180"]
      }
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]

  def sports_disciplines_routes do
    [
      "africa",
      "american-football",
      "archery",
      "athletics",
      "badminton",
      "baseball",
      "basketball",
      "bodypositive",
      "bowls",
      "boxing",
      "canoeing",
      "commonwealth-games",
      "cricket",
      "cycling",
      "darts",
      "disability-sport",
      "diving",
      "england",
      "equestrian",
      "fencing",
      "football",
      "formula1",
      "formula-one",
      "gaelic-games",
      "get-inspired",
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
      "motogp",
      "motorsport",
      "netball",
      "northern-ireland",
      "olympics",
      "rowing",
      "rugby-league",
      "rugby-union",
      "sailing",
      "scotland",
      "shooting",
      "skateboarding",
      "snooker",
      "speedway",
      "sport-climbing",
      "sports-personality",
      "squash",
      "surfing",
      "swimming",
      "table-tennis",
      "taekwondo",
      "tennis",
      "triathlon",
      "volleyball",
      "wales",
      "water-polo",
      "weightlifting",
      "winter-olympics",
      "winter-sports",
      "wrestling"
   ]
  end
end
