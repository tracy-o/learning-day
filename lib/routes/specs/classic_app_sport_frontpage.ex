defmodule Routes.Specs.ClassicAppSportFrontpage do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/sport/front-page"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/sport/front-page"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/sport/front-page"]
        }
      ]
    }
  end
end
