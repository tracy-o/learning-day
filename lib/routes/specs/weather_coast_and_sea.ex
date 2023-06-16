defmodule Routes.Specs.WeatherCoastAndSea do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        caching_enabled: false,
        examples: ["/weather/coast-and-sea", "/weather/coast-and-sea/inshore-waters", "/weather/coast-and-sea/tide-tables/1/111a", "/weather/coast-and-sea/tide-tables/1", "/weather/coast-and-sea/tide-tables"]
      }
    }
  end
end
