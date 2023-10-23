defmodule Routes.Specs.WorldServiceArabic do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/arabic/popular/read", "/arabic.json", "/arabic.amp"]
      }
    }
  end
end
