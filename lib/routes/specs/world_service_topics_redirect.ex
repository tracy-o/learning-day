defmodule Routes.Specs.WorldServiceTopicsRedirect do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsRedirect"]
    }
  end
end
