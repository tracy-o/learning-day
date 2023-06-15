defmodule Routes.Specs.ClassicAppStaticContent do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/static/LE/android/1.5.0/config.json", "/static/MUNDO/ios/5.19.0/layouts.zip"]
      }
    }
  end
end
