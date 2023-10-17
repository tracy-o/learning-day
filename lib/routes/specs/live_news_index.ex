defmodule Routes.Specs.LiveNewsIndex do
  def specification do
    %{
      specs: %{
        request_pipeline: ["BBCXRedirect"],
        platform: "BBCX",
        examples: [
          "/live/news",
        ]
      }
    }
  end
end
