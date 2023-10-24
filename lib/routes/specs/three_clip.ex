defmodule Routes.Specs.ThreeClip do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        examples: ["/bbcthree/clip/9a7c7cf2-5502-4806-ac85-9e7208b50a0a"]
      }
    }
  end
end
