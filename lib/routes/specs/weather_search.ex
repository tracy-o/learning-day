defmodule Routes.Specs.WeatherSearch do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        examples: ["/weather/search?s=london"]
      }
    }
  end
end
