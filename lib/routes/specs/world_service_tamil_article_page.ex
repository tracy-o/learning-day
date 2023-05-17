defmodule Routes.Specs.WorldServiceTamilArticlePage do
  def specification do
    %{
      specs: %{
        platform: "Simorgh",
        request_pipeline: ["WorldServiceRedirect"]
      }
    }
  end
end
