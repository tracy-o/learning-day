defmodule Routes.Specs.ProgrammesData do
  def specification(_production_env) do
    %{
      specs: %{
        email: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        examples: ["/programmes/b006m8dq.json", "/programmes/b006m8dq/series.json", "/programmes/b01m2fyy/segments.json", "/programmes/b08lkyzk/playlist.json", "/programmes/b006m8dq/episodes.json", "/programmes/b006m8dq/episodes/2020/12.json", "/programmes/b04drklx/episodes/upcoming.json", "/programmes/b006m8dq/episodes/last.json", "/programmes/b006m8dq/children.json", "/programmes/snippet/n45bj5.json", "/programmes/a-z.json", "/programmes/a-z/player.json", "/programmes/a-z/all.json", "/programmes/a-z/by/b.json", "/programmes/a-z/by/b/all.json", "/programmes/a-z/by/b/player.json"]
      }
    }
  end
end
