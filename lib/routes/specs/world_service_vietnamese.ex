defmodule Routes.Specs.WorldServiceVietnamese do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/vietnamese/popular/read"]
      }
    }
  end
end
