defmodule Routes.Specs.ClassicAppFlagpole do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/flagpoles/ads"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/flagpoles/ads"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/flagpoles/ads"]
        }
      ]
    }
  end
end
