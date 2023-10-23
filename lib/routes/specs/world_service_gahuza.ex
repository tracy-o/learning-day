defmodule Routes.Specs.WorldServiceGahuza do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gahuza/popular/read"]
      }
    }
  end
end
