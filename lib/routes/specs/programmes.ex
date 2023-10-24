defmodule Routes.Specs.Programmes do
  def specification(_production_env) do
    %{
      specs: %{
        email: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        examples: [%{expected_status: 301, path: "/programmes/topics"}, %{expected_status: 301, path: "/programmes/topics/Performers_of_Sufi_music"}, %{expected_status: 301, path: "/programmes/topics/21st-century_American_non-fiction_writers/video"}, %{expected_status: 301, path: "/programmes/topics/21st-century_American_non-fiction_writers/audio"}, %{expected_status: 301, path: "/programmes/topics/Documentary_films_about_HIV/AIDS"}, %{expected_status: 301, path: "/programmes/profiles/23ca89bd-f35e-4803-bb86-c300c88afb2f"}, %{expected_status: 301, path: "/programmes/profiles/5NGNHQKKXGsFfnkxPBzKPMW"}, "/programmes/profiles/5NGNHQKKXGsFfnkxPBzKPMW/alistair-lloyd", "/programmes/genres/childrens", "/programmes/genres/comedy/sitcoms", "/programmes/genres/childrens/all", "/programmes/genres/childrens/player", "/programmes/genres/comedy/music/player", "/programmes/genres/comedy/music/all", "/programmes/genres/factual/scienceandnature/scienceandtechnology/player", "/programmes/genres/factual/scienceandnature/scienceandtechnology", "/programmes/genres", "/programmes/formats", "/programmes/formats/animation", "/programmes/formats/animation/all", "/programmes/formats/animation/player", "/programmes/a-z", "/programmes/a-z/by/b/all", "/programmes/a-z/by/b/player"]
      }
    }
  end
end
