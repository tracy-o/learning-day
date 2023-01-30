defmodule Routes.Specs.WeatherLanguage do
  def specs do
    %{
      platform: "MozartWeather",
      request_pipeline: ["WeatherLanguageCookie"]
    }
  end
end
