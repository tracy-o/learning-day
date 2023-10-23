defmodule Routes.Specs.WorldServiceSomali do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/somali/popular/read"]
      }
    }
  end
end
