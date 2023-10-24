defmodule Routes.Specs.NewsAmp do
  def specification do
    %{
      specs: %{
        slack_channel: "#support-simorgh",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
        platform: "Simorgh",
        examples: ["/news/business-58847275.amp"]
      }
    }
  end
end
