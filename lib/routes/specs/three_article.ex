defmodule Routes.Specs.ThreeArticle do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        examples: ["/bbcthree/article/cea4efdd-42fe-4ed4-8734-3d7f6c3cf0b2"]
      }
    }
  end
end
