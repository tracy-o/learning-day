defmodule Routes.Specs.WorldServiceSinhala do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/sinhala/popular/read"]
      }
    }
  end
end
