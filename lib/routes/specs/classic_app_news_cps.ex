defmodule Routes.Specs.ClassicAppNewsCps do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/news/uk-england-london-59333481"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/news/uk-england-london-59333481"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/news/uk-england-london-59333481"]
        }
      ]
    }
  end
end
