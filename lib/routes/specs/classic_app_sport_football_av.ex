defmodule Routes.Specs.ClassicAppSportFootballAv do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/sport/av/football/59346509"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/sport/av/football/59346509"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/sport/av/football/59346509"]
        }
      ]
    }
  end
end
