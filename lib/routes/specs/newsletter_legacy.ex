defmodule Routes.Specs.NewsletterLegacy do
  def specification do
    %{
      specs: %{
        owner: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Newsletters+Runbook",
        platform: "MorphRouter",
        request_pipeline: ["ComToUKRedirect"],
        examples: [
          %{
            path: "/newsletters/daily_news/zbdmwty",
            headers: %{"x-forwarded-host" => "www.bbc.co.uk"}
          }
        ]
      }
    }
  end
end
