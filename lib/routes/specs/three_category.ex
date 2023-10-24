defmodule Routes.Specs.ThreeCategory do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        examples: ["/bbcthree/category/crime", "/bbcthree/category/crime/2"]
      }
    }
  end
end
