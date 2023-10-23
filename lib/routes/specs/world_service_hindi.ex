defmodule Routes.Specs.WorldServiceHindi do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/hindi/popular/read", "/hindi.json", "/hindi.amp"]
      }
    }
  end
end
