defmodule Routes.Specs.WorldServiceRussian do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/russian/popular/read", "/russian.json", "/russian.amp"]
      }
    }
  end
end
