defmodule Routes.Specs.ClassicAppMundo do
  def specification do
    %{
      specs: %{
        owner: "#data-systems",
        runbook: "https://confluence.dev.bbc.co.uk/display/TREVOR/Trevor+V3+%28News+Apps+Data+Service%29+Runbook",
        platform: "ClassicApps",
        query_params_allowlist: ["subjectId", "language", "createdBy"],
        etag: true,
        examples: ["/content/cps/mundo/vert-cap-59223070?createdBy=mundo&language=es", "/content/cps/mundo/noticias-59340165?createdBy=mundo&language=es"]
      }
    }
  end
end
