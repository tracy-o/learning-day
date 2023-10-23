defmodule Routes.Specs.WorldServiceAzeri do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/azeri/popular/read"]
      }
    }
  end
end
