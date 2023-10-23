defmodule Routes.Specs.WorldServiceMundo do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/mundo/popular/read", "/mundo.json", "/mundo.amp"]
      }
    }
  end
end
