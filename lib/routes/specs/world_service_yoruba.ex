defmodule Routes.Specs.WorldServiceYoruba do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/yoruba/popular/read"]
      }
    }
  end
end
