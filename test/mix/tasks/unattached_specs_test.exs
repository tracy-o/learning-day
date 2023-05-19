defmodule Mix.Tasks.UnattachedSpecsTest do
  use ExUnit.Case
  alias Mix.Tasks.UnattachedSpecs

  test "find_unattached_specs/2 returns spec modules that are unused by a route spec" do
    route_specs = [
      %{env: "live", owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk", platform: "Webcore", route: "/", spec: "HomePage"},
      %{
        env: "live",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/scotland",
        spec: "ScotlandHomePage"
      },
      %{
        env: "test",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/homepage/test",
        spec: "TestHomePage"
      },
      %{
        env: "test",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/homepage/automation",
        spec: "AutomationHomePage"
      },
      %{
        env: "live",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/northernireland",
        spec: "NorthernIrelandHomePage"
      },
      %{
        env: "live",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/wales",
        spec: "WalesHomePage"
      },
      %{
        env: "live",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/cymru",
        spec: "CymruHomePage"
      },
      %{
        env: "live",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/alba",
        spec: "AlbaHomePage"
      },
      %{
        env: "test",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/newstipo",
        spec: "NewsTipoHomePage"
      },
      %{
        env: "test",
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        platform: "Webcore",
        route: "/homepage/news/preview",
        spec: "NewsHomePagePreview"
      }
    ]

    spec_modules = [
      "HomePage",
      "ScotlandHomePage",
      "TestHomePage",
      "AutomationHomePage",
      "NorthernIrelandHomePage",
      "WalesHomePage",
      "CymruHomePage",
      "AlbaHomePage",
      "NewsTipoHomePage",
      "NewsHomePagePreview",
      "ClassicAppFablLdp",
      "ClassicAppId",
      "ClassicAppLearningEnglish",
      "ClassicAppMundo",
      "ClassicAppNewsAudioVideo"
    ]

    unattached_specs = [
      "ClassicAppFablLdp",
      "ClassicAppId",
      "ClassicAppLearningEnglish",
      "ClassicAppMundo",
      "ClassicAppNewsAudioVideo"
    ]

    result = UnattachedSpecs.find_unattached_specs(spec_modules, route_specs)

    assert result == unattached_specs
  end
end
