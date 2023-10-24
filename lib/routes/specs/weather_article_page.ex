defmodule Routes.Specs.WeatherArticlePage do
  def specification do
    %{
      specs: %{
        email: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
        platform: "Webcore",
        examples: ["/weather/feeds/23602910", "/weather/feeds/23081292", %{expected_status: 301, path: "/weather/feeds/64827801"}, "/weather/features/63962965", "/weather/features/60850659", %{expected_status: 301, path: "/weather/features/63895092"}, "/weather/about/17185651", "/weather/about/17543675", %{expected_status: 301, path: "/weather/about/42960629"}, "/weather/weather-watcher/35549771", "/weather/weather-watcher/37021677", "/weather/weather-watcher/48748763"]
      }
    }
  end
end
