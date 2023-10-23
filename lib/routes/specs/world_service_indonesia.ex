defmodule Routes.Specs.WorldServiceIndonesia do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/indonesia/popular/read"]
      }
    }
  end
end
