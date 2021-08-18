defmodule Routes.Specs.NewsLive do
  def specs do
    %{
      platform: MozartNews,
      circuit_breaker_error_threshold: 500
    }
  end
end
