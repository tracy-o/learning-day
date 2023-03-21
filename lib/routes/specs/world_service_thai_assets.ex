defmodule Routes.Specs.WorldServiceThaiAssets do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
