defmodule Routes.Specs.WorldServiceKoreanAssets do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
