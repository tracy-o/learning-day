defmodule Routes.Specs.PhoPublicContent do
  def specification do
    %{
      specs: %{
        owner: "#platform-health",
        platform: "Webcore",
        personalisation: "off",
        examples: ["/_health/public_content"]
      }
    }
  end
end
