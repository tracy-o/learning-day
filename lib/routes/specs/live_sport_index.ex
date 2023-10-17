defmodule Routes.Specs.LiveSportIndex do
  def specification do
    %{
      specs: %{
        request_pipeline: ["BBCXRedirect"],
        platform: "BBCX",
        examples: [
          "/live/sport",
        ]
      }
    }
  end
end
