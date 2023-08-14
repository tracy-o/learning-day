defmodule Routes.Specs.ThreeHomePage do
  def specification do
    %{
      specs: %{
        owner: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        examples: ["/bbcthree"]
      }
    }
  end
end
