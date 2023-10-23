defmodule Routes.Specs.WorldServiceMarathi do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/marathi/popular/read"]
      }
    }
  end
end
