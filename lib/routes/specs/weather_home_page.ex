defmodule Routes.Specs.WeatherHomePage do
  def specs do
    %{
      owner: "DENewsElections@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=140399154",
      platform: MozartWeather,
      headers_allowlist: ["cookie-ckps_language"]
    }
  end
end
