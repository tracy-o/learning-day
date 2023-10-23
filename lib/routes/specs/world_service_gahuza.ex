defmodule Routes.Specs.WorldServiceGahuza do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/gahuza/popular/read"]
      }
    }
  end
end
