defmodule Routes.Specs.WorldServiceHindiAppArticlePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"]
      }
    }
  end
end
