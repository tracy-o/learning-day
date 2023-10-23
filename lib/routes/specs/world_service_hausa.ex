defmodule Routes.Specs.WorldServiceHausa do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/hausa/popular/read", "/hausa.json", "/hausa.amp"]
      }
    }
  end
end
