defmodule Routes.Specs.WorldServiceUzbek do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/uzbek", "/uzbek.json", "/uzbek.amp"]
      }
    }
  end
end
