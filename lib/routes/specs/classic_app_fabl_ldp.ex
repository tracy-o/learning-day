defmodule Routes.Specs.ClassicAppFablLdp do
  def specs do
    %{
      owner: "D&EMorphCoreEngineering@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/WebCore/FABL+Run+Book",
      platform: Fabl,
      request_pipeline: ["ClassicAppFablLdp"],
      etag: true
    }
  end
end
