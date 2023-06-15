defmodule Routes.Specs.WorldServiceTajik do
  def specification do
    %{
      specs: %{
        platform: "MozartNews",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/tajik"]
      }
    }
  end
end
