defmodule Routes.Specs.ClassicAppSportLive do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/content/cps/sport/live/football/59369278", "/content/cps/sport/live/formula1/58748830"]
      }
    }
  end
end
