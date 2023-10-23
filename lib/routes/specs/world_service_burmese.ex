defmodule Routes.Specs.WorldServiceBurmese do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/burmese/popular/read"]
      }
    }
  end
end
