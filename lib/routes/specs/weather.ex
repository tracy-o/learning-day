defmodule Routes.Specs.Weather do
  def specification do
    %{
      specs: %{
        platform: "MozartWeather",
        examples: ["/weather/error/404", "/weather/error/500", "/weather/map", "/weather/outlook"]
      }
    }
  end
end
