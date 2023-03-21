defmodule Routes.Specs.WorldServiceTurkceArticlePage do
  def specs do
    %{
      platform: "Simorgh",
      request_pipeline: ["WorldServiceRedirect"]
    }
  end
end
