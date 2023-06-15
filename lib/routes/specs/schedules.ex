defmodule Routes.Specs.Schedules do
  def specification(_production_env) do
    %{
      specs: %{
        owner: "homedatacap@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=152098352",
        platform: "Programmes",
        examples: ["/schedules", "/schedules/p00fzl6v/2021/06/28", "/schedules/p05pkt1d/2020/w02", "/schedules/p05pkt1d/2020/01", %{expected_status: 302, path: "/schedules/p05pkt1d/yesterday"}, "/schedules/p05pkt1d/2021", %{expected_status: 301, path: "/schedules/network/radioscotland"}, %{expected_status: 302, path: "/schedules/network/bbcone/on-now"}]
      }
    }
  end
end
