defmodule Routes.Specs.DotComTravelAny do
  def specification do
    %{
      specs: %{
        request_pipeline: [],
        platform: "DotComTravel",
        examples: ["/travel/tags"]
      }
    }
  end
end
