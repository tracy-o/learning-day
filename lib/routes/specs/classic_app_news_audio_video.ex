defmodule Routes.Specs.ClassicAppNewsAudioVideo do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/content/cps/news/video_and_audio/ten_to_watch", "/content/cps/news/video_and_audio/top_stories"]
      }
    }
  end
end
