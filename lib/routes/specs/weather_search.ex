defmodule Routes.Specs.WeatherSearch do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        examples: ["/weather/search?s=london", "/weather/search?s=london&page=0"]
      }
    }
  end
end
