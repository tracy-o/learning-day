defmodule Routes.Specs.WorldServiceRussianAssets do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
