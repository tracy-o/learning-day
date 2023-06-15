defmodule Routes.Specs.ClassicAppHindi do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/content/cps/hindi/india?createdBy=hindi&language=hi", "/content/cps/hindi/india-59277161?createdBy=hindi&language=hi"]
      }
    }
  end
end
