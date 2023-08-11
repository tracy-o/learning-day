defmodule Routes.Specs.WeatherLanguage do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        request_pipeline: ["WeatherLanguageCookie"],
        examples: [%{expected_status: 301, path: "/weather/language/en"}]
      }
    }
  end
end
