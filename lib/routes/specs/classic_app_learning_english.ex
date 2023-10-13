defmodule Routes.Specs.ClassicAppLearningEnglish do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/learning_english/home", "/content/cps/learning_english/6-minute-english-59142810"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/learning_english/home", "/content/cps/learning_english/6-minute-english-59142810"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/learning_english/home", "/content/cps/learning_english/6-minute-english-59142810"]
        }
      ]
    }
  end
end
