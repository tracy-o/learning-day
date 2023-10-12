defmodule Routes.Specs.ClassicAppNewsround do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/newsround/45274517"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/newsround/45274517"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/newsround/45274517"]
        }
      ]
    }
  end
end
