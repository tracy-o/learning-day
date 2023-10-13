defmodule Routes.Specs.ClassicAppNewsFrontpage do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/news/front_page"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/news/front_page"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/news/front_page"]
        }
      ]
    }
  end
end
