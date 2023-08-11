defmodule Routes.Specs.ProgrammesEntity do
  def specification(_production_env) do
    %{
      specs: %{
        owner: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        examples: ["/programmes/b006m8dq", "/programmes/p028d9jw/p028d8nr", %{expected_status: 301, path: "/programmes/b00lvdrj/topics"}, %{expected_status: 301, path: "/programmes/b00lvdrj/topics/1091_Media_films"}, "/programmes/b006v5y2/recipes", "/programmes/b006v5y2/recipes.2013inc", "/programmes/b006v5y2/recipes.ameninc", "/programmes/b006qpgr/profiles", "/programmes/p097pw9q/player", "/programmes/b045fz8r/galleries", %{expected_status: 302, path: "/programmes/b006m8dq/episodes"}, "/programmes/b006m8dq/episodes/player", "/programmes/p02zmzss/episodes/guide.2013inc", "/programmes/b006m8dq/episodes/guide", "/programmes/p02nrw8y/episodes/downloads", "/programmes/b006qj9z/contact", "/programmes/b045fz8r/clips"]
      }
    }
  end
end
