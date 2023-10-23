defmodule Routes.Specs.WorldServiceIgbo do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/igbo/popular/read"]
      }
    }
  end
end
