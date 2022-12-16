defmodule Routes.Specs.WeatherLanguage do
  def specs(env) do
    %{
      platform: MozartWeather,
      request_pipeline: request_pipeline(env)
    }
  end

  defp request_pipeline("live"), do: ["WeatherLanguageCookie", "CircuitBreaker"]
  defp request_pipeline(_production_env), do: request_pipeline("live") ++ ["DevelopmentRequests"]
end
