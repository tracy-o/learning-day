defmodule Routes.Specs.MyTopicsFollows do
  def specs do
    %{
      owner: "DandESportApp@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/sportws4/My+Topics+Run+Book",
      platform: Fabl,
      personalisation: "on",
      fallback_write_sample: 0,
      caching_enabled: false
    }
  end
end
