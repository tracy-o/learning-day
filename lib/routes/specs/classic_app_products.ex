defmodule Routes.Specs.ClassicAppProducts do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{platform: "AppsTrevor"},
        %{platform: "AppsWalter"},
        %{platform: "AppsPhilippa"}
      ]
    }
  end
end
