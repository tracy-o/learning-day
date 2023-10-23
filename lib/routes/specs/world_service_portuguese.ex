defmodule Routes.Specs.WorldServicePortuguese do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/portuguese/popular/read"]
      }
    }
  end
end
