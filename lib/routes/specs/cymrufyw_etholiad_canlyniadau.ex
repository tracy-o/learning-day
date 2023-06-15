defmodule Routes.Specs.CymrufywEtholiadCanlyniadau do
  def specification do
    %{
      specs: %{
        owner: "DENewsElections@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/connpol/Operational+support",
        platform: "Webcore",
        default_language: "cy",
        examples: ["/cymrufyw/etholiad/2022/cymru/cynghorau", "/cymrufyw/etholiad/2022/cymru/canlyniadau", "/cymrufyw/etholiad/2021/cymru/canlyniadau"]
      }
    }
  end
end
