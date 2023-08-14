defmodule Routes.Specs.ThreeRedirect do
  def specification do
    %{
      specs: %{
        owner: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        request_pipeline: ["ThreeItemsRedirect"],
        examples: [%{expected_status: 301, path: "/bbcthree/item/febba241-7d72-4869-94b4-b4eba3fb7840"}]
      }
    }
  end
end
