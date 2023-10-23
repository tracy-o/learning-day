defmodule Routes.Specs.WorldServicePidgin do
  def specification do
    %{
      specs: %{
        platform: "MozartSimorgh",
        request_pipeline: ["WorldServiceRedirect"],
        examples: ["/pidgin/popular/read"]
      }
    }
  end
end
