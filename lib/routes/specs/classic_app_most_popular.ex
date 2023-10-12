defmodule Routes.Specs.ClassicAppMostPopular do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/most_popular/news"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/most_popular/news"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/most_popular/news"]
        }
      ]
    }
  end
end
