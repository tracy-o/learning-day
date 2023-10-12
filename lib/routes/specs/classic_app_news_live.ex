defmodule Routes.Specs.ClassicAppNewsLive do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/news/live/world-africa-47639452"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/news/live/world-africa-47639452"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/news/live/world-africa-47639452"]
        }
      ]
    }
  end
end
