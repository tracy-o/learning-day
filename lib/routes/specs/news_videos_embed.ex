defmodule Routes.Specs.NewsVideosEmbed do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        query_params_allowlist: ["amp"],
        examples: [%{expected_status: 302, path: "/news/health-54088206/embed/p08m8yx4"}, %{expected_status: 302, path: "/news/health-54088206/embed/p08m8yx4?amp=1"}, %{expected_status: 302, path: "/news/health-54088206/embed"}, %{expected_status: 302, path: "/news/uk-politics-54003483/embed?amp=1"}, %{expected_status: 302, path: "/news/av/embed/p07pd78q/49843970"}, %{expected_status: 302, path: "/news/av/business-49843970/i-built-my-software-empire-from-a-stoke-council-house/embed"}, %{expected_status: 302, path: "/news/av/world-us-canada-50294316/embed"}]
      }
    }
  end

end
