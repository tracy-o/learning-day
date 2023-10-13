defmodule Routes.Specs.ClassicApp do
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
