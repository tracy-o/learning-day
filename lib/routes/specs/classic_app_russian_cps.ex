defmodule Routes.Specs.ClassicAppRussianCps do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/content/cps/russian/front_page?createdBy=russian&language=ru", "/content/cps/russian/news?createdBy=russian&language=ru", "/content/cps/russian/features-58536209?createdBy=russian&language=ru"]
      }
    }
  end
end
