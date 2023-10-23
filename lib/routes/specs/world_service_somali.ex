defmodule Routes.Specs.WorldServiceSomali do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/somali/popular/read"]
      }
    }
  end
end
