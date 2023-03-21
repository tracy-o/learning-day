defmodule Routes.Specs.WorldServiceSerbianAssets do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
