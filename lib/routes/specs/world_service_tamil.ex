defmodule Routes.Specs.WorldServiceTamil do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tamil/popular/read"]
      }
    }
  end
end
