defmodule Routes.Specs.WeatherCoastAndSea do
  def specs do
    %{
      owner: "DEWeather@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=140399154",
      platform: MozartWeather,
      headers_allowlist: ["cookie-ckps_language"],
      caching_enabled: false
    }
  end
end