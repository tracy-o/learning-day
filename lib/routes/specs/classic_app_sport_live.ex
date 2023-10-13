defmodule Routes.Specs.ClassicAppSportLive do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/sport/live/football/59369278", "/content/cps/sport/live/formula1/58748830"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/sport/live/football/59369278", "/content/cps/sport/live/formula1/58748830"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/sport/live/football/59369278", "/content/cps/sport/live/formula1/58748830"]
        }
      ]
    }
  end
end
