defmodule Routes.Specs.SportVideos do
  def specs(production_env) do
    %{
      owner: "sfv-team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
      platform: Webcore,
      query_params_allowlist: query_params_allowlist(production_env),
      pipeline: pipeline(production_env)
    }
  end

  defp query_params_allowlist("live"), do: []
  defp query_params_allowlist(_production_env), do: ["features"]

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "Language", "DatalabMachineRecommendations", "PlatformKillSwitch", "Chameleon", "CircuitBreaker"]
  end

  defp pipeline(_production_env) do
    pipeline("live") ++ ["DevelopmentRequests"]
  end

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
