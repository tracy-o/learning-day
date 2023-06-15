defmodule Routes.Specs.NewsAmp do
  def specification do
    %{
      specs: %{
        owner: "#support-simorgh",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
        platform: "MozartSimorgh",
        examples: ["/news/business-58847275.json", "/news/business-58847275.amp"]
      }
    }
  end
end
