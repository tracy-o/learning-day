defmodule Routes.Specs.WorldServiceTopicsRedirect do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect", "WorldServiceTopicsRedirect"]
      }
    }
  end
end
