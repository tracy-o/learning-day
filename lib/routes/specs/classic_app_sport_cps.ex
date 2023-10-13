defmodule Routes.Specs.ClassicAppSportCps do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/sport/rugby-union/59369204", "/content/cps/sport/tennis/59328440"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/sport/rugby-union/59369204", "/content/cps/sport/tennis/59328440"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/sport/rugby-union/59369204", "/content/cps/sport/tennis/59328440"]
        }
      ]
    }
  end
end
