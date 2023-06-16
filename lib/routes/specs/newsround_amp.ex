defmodule Routes.Specs.NewsroundAmp do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/newsround/articles/manifest.json", "/newsround/61545299.json", "/newsround/61545299.amp"]
      }
    }
  end
end
