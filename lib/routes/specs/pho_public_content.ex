defmodule Routes.Specs.PhoPublicContent do
  def specification do
    %{
      specs: %{
        slack_channel: "#platform-health",
        platform: "Webcore",
        personalisation: "off",
        examples: ["/_health/public_content"]
      }
    }
  end
end
