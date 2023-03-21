defmodule Routes.Specs.WorldServicePidginAssets do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
