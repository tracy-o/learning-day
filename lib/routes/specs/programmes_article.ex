defmodule Routes.Specs.ProgrammesArticle do
  def specification(_production_env) do
    %{
      specs: %{
        owner: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        examples: ["/programmes/b006m8dq/articles", %{expected_status: 301, path: "/programmes/articles/4xJyCpMp64NcCXD0FVlhmSz"}, "/programmes/articles/4xJyCpMp64NcCXD0FVlhmSz/frequently-asked-questions"]
      }
    }
  end
end
