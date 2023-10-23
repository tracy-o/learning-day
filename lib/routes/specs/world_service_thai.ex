defmodule Routes.Specs.WorldServiceThai do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/thai/popular/read"]
      }
    }
  end
end
