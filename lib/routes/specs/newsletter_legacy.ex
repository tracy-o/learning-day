defmodule Routes.Specs.NewsletterLegacy do
  def specification do
    %{
      specs: %{
        owner: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Newsletters+Runbook",
        platform: "MorphRouter",
        request_pipeline: ["ComToUKRedirect"],
        examples: ["/newsletters/daily_news/zbdmwty"]
      }
    }
  end
end
