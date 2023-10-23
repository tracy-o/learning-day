defmodule Routes.Specs.WorldServiceAfaanoromoo do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/afaanoromoo/popular/read"]
      }
    }
  end
end
