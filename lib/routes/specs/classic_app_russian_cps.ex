defmodule Routes.Specs.ClassicAppRussianCps do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
           examples: ["/content/cps/russian/front_page?createdBy=russian&language=ru", "/content/cps/russian/news?createdBy=russian&language=ru", "/content/cps/russian/features-58536209?createdBy=russian&language=ru"]
        },
        %{
          platform: "AppsWalter",
           examples: ["/content/cps/russian/front_page?createdBy=russian&language=ru", "/content/cps/russian/news?createdBy=russian&language=ru", "/content/cps/russian/features-58536209?createdBy=russian&language=ru"]
        },
        %{
          platform: "AppsPhilippa",
           examples: ["/content/cps/russian/front_page?createdBy=russian&language=ru", "/content/cps/russian/news?createdBy=russian&language=ru", "/content/cps/russian/features-58536209?createdBy=russian&language=ru"]
        }
      ]
    }
  end
end
