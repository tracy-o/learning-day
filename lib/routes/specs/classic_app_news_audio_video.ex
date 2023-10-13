defmodule Routes.Specs.ClassicAppNewsAudioVideo do
  def specification do
        %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/news/video_and_audio/ten_to_watch", "/content/cps/news/video_and_audio/top_stories"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/news/video_and_audio/ten_to_watch", "/content/cps/news/video_and_audio/top_stories"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/news/video_and_audio/ten_to_watch", "/content/cps/news/video_and_audio/top_stories"]
        }
      ]
    }
  end
end
