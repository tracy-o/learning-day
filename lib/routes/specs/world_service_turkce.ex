defmodule Routes.Specs.WorldServiceTurkce do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/turkce/popular/read"]
      }
    }
  end
end
