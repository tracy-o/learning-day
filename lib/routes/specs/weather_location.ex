defmodule Routes.Specs.WeatherLocation do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        examples: ["/weather/2650225/today", "/weather/2650225"]
      }
    }
  end
end
