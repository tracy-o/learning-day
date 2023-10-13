defmodule Routes.Specs.ClassicAppHindi do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/hindi/india?createdBy=hindi&language=hi", "/content/cps/hindi/india-59277161?createdBy=hindi&language=hi"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/hindi/india?createdBy=hindi&language=hi", "/content/cps/hindi/india-59277161?createdBy=hindi&language=hi"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/hindi/india?createdBy=hindi&language=hi", "/content/cps/hindi/india-59277161?createdBy=hindi&language=hi"]
        }
      ]
    }
  end
end
