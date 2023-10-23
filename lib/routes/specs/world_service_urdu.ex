defmodule Routes.Specs.WorldServiceUrdu do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/urdu/popular/read"]
      }
    }
  end
end
