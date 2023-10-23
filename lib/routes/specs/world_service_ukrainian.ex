defmodule Routes.Specs.WorldServiceUkrainian do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/ukrainian/popular/read"]
      }
    }
  end
end
