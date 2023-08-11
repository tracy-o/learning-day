defmodule Routes.Specs.WeatherWarnings do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        examples: ["/weather/warnings/floods", "/weather/warnings/weather"]
      }
    }
  end
end
