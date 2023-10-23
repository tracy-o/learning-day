defmodule Routes.Specs.WorldServiceTelugu do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/telugu/popular/read"]
      }
    }
  end
end
