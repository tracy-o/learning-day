defmodule Routes.Specs.NewsroundStorytellingAmp do
  def specification do
    %{
      specs: %{
        slack_channel: "#support-simorgh",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSART/Simorgh+Run+Book",
        platform: "Simorgh",
        examples: ["/newsround/articles/c3gv75nj0mzo.amp"]
      }
    }
  end
end
