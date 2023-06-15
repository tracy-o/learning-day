defmodule Routes.Specs.ClassicAppArabic do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/content/cps/arabic/live/53833263?createdBy=arabic&language=ar", "/content/cps/arabic/art-and-culture-59307957?createdBy=arabic&language=ar"]
      }
    }
  end
end
