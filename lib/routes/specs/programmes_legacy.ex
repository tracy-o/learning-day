defmodule Routes.Specs.ProgrammesLegacy do
  def specification(_production_env) do
    %{
      specs: %{
        owner: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        examples: [%{expected_status: 301, path: "/programmes/b006m8dq.html"}, %{expected_status: 301, path: "/programmes/b006m8dq/series"}, %{expected_status: 301, path: "/programmes/b01m2fz4/segments"}, %{expected_status: 301, path: "/programmes/p02str2y/schedules/2019/03/18"}, %{expected_status: 301, path: "/programmes/p02str2y/schedules"}, %{expected_status: 301, path: "/programmes/p02nrw8y/podcasts"}, %{expected_status: 301, path: "/programmes/p001rshg/microsite"}, %{expected_status: 301, path: "/programmes/p001rshg/members"}, %{expected_status: 301, path: "/programmes/p001rshg/members/all"}, %{expected_status: 301, path: "/programmes/p02nrw8y/episodes/downloads.rss"}, %{expected_status: 301, path: "/programmes/b006qnmr/episodes/a-z/a"}, %{expected_status: 301, path: "/programmes/b06ss3j4/credits"}, %{expected_status: 302, path: "/programmes/w172vkw6f1ffv5f/broadcasts"}, %{expected_status: 302, path: "/programmes/b006qsq5/broadcasts/2020/01"}, %{expected_status: 301, path: "/programmes/a-z/by/b"}, %{expected_status: 301, path: "/programmes/a-z/by/b/current"}, %{expected_status: 301, path: "/programmes/a-z/current"}, %{expected_status: 301, path: "/programmes/articles/49FbN1s7dwnWXBmHRGK308B/5-unforgettable-moments-from-the-semi-final/contact"}]
      }
    }
  end
end
