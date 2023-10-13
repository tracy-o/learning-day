defmodule Routes.Specs.ClassicAppArabic do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/arabic/live/53833263?createdBy=arabic&language=ar", "/content/cps/arabic/art-and-culture-59307957?createdBy=arabic&language=ar"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/arabic/live/53833263?createdBy=arabic&language=ar", "/content/cps/arabic/art-and-culture-59307957?createdBy=arabic&language=ar"]
        },
        %{
          platform: "AppsPhilippa",
examples: ["/content/cps/arabic/live/53833263?createdBy=arabic&language=ar", "/content/cps/arabic/art-and-culture-59307957?createdBy=arabic&language=ar"]
        }
      ]
    }
  end
end
