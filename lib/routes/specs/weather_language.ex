defmodule Routes.Specs.WeatherLanguage do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        request_pipeline: ["WeatherLanguageCookie"]
      }
    }
  end
end
