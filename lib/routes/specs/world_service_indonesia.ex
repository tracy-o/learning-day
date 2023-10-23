defmodule Routes.Specs.WorldServiceIndonesia do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/indonesia/popular/read"]
      }
    }
  end
end
