defmodule Routes.Specs.NewsHomePage do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      platform: MozartNews,
      pipeline: ["HTTPredirect", "TrailingSlashRedirector"]
    }
  end
end
