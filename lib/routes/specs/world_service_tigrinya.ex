defmodule Routes.Specs.WorldServiceTigrinya do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tigrinya/popular/read"]
      }
    }
  end
end
