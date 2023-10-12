defmodule Routes.Specs.ClassicAppSportFootball do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/sport/football/59372826", "/content/cps/sport/football/58643317"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/sport/football/59372826", "/content/cps/sport/football/58643317"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/sport/football/59372826", "/content/cps/sport/football/58643317"]
        }
      ]
    }
  end
end
