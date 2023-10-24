defmodule Routes.Specs.PhoPrivateContent do
  def specification do
    %{
      specs: %{
        slack_channel: "#platform-health",
        platform: "Webcore",
        personalisation: "on",
        examples: ["/_health/private_content"]
      }
    }
  end
end
