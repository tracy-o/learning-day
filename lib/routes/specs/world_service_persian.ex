defmodule Routes.Specs.WorldServicePersian do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/persian/popular/read", "/persian.json", "/persian.amp"]
      }
    }
  end
end
