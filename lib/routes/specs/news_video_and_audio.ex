defmodule Routes.Specs.NewsVideoAndAudio do
  def specification do
    %{
      specs: %{
        owner: "sfv-team@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/SFV/Short+Form+Video+Run+Book",
        platform: "Webcore",
        examples: [%{expected_status: 301, path: "/news/video_and_audio/must_see/54327412/scientists-create-a-microscopic-robot-that-walks"}]
      }
    }
  end
end
