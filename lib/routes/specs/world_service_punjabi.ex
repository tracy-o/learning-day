defmodule Routes.Specs.WorldServicePunjabi do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/punjabi/popular/read"]
      }
    }
  end
end
