defmodule Routes.Specs.ThreeSitemap do
  def specification do
    %{
      specs: %{
        slack_channel: "#help-topics",
        runbook: "https://confluence.dev.bbc.co.uk/display/bbc3web/BBC3+Digital+Run+book",
        platform: "Three",
        examples: ["/bbcthree/sitemap.xml"]
      }
    }
  end
end
