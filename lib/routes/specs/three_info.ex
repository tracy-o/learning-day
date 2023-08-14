defmodule Routes.Specs.ThreeInfo do
  def specification do
    %{
      specs: %{
        owner: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        examples: ["/bbcthree/privacy", "/bbcthree/terms-and-conditions", "/bbcthree/twitter-polls-terms-and-conditions"]
      }
    }
  end
end
