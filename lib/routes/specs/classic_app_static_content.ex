defmodule Routes.Specs.ClassicAppStaticContent do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/static/LE/android/1.5.0/config.json", "/static/MUNDO/ios/5.19.0/layouts.zip"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/static/LE/android/1.5.0/config.json", "/static/MUNDO/ios/5.19.0/layouts.zip"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/static/LE/android/1.5.0/config.json", "/static/MUNDO/ios/5.19.0/layouts.zip"]
        }
      ]
    }
  end
end
