defmodule Routes.Specs.WorldServiceAmharic do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/amharic/popular/read"]
      }
    }
  end
end
