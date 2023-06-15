defmodule Routes.Specs.WeatherHomePage do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        fallback_write_sample: 0.5,
        examples: ["/weather"]
      }
    }
  end
end
