defmodule Routes.Specs.WorldServiceGujarati do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gujarati/popular/read"]
      }
    }
  end
end
