defmodule Routes.Specs.BBCX do
  def specification do
    %{
      specs: %{
        request_pipeline: ["BBCXRedirect"],
        platform: "BBCX",
        examples: ["/news/war-in-ukraine", "/innovation"]
      }
    }
  end
end