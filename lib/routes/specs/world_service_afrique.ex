defmodule Routes.Specs.WorldServiceAfrique do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/afrique/popular/read", "/afrique.json", "/afrique.amp"]
      }
    }
  end
end
