defmodule Routes.Specs.ProgrammesHomePage do
  def specs(_production_env) do
    %{
      owner: "homedatacap@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
      platform: "Programmes",
      fallback_write_sample: 0.5
    }
  end
end
