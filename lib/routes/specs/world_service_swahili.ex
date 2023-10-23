defmodule Routes.Specs.WorldServiceSwahili do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/swahili/popular/read", "/swahili.json", "/swahili.amp"]
      }
    }
  end
end
