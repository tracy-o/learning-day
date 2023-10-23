defmodule Routes.Specs.WorldServiceRussian do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/russian/popular/read", "/russian.json", "/russian.amp"]
      }
    }
  end
end
