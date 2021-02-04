defmodule Routes.Specs.NewsLive do
  def specs do
    %{
      platform: Mozart,
      circuit_breaker_error_threshold: 500,
      pipeline: ["HTTPredirect"]
    }
  end
end
