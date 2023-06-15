defmodule Routes.Specs.NewsBusiness do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/news/business/companies", "/news/business-45489065", "/news/business-38507481", "/news/business-33712313", "/news/business-15521824", "/news/business-11428889"]
      }
    }
  end
end
