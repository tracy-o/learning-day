defmodule Routes.Specs.WorldServiceUrdu do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/urdu/popular/read"]
      }
    }
  end
end
