defmodule Routes.Specs.WorldServiceNepali do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/nepali/popular/read"]
      }
    }
  end
end
