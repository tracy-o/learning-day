defmodule Routes.Specs.ProgrammesHomePage do
  def specification(_production_env) do
    %{
      specs: %{
        email: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        fallback_write_sample: 0.5,
        examples: ["/programmes"]
      }
    }
  end
end
