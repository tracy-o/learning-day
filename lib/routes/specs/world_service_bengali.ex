defmodule Routes.Specs.WorldServiceBengali do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/bengali/popular/read"]
      }
    }
  end
end
