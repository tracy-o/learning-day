defmodule Routes.Specs.Cymrufyw do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/cymrufyw", %{expected_status: 301, path: "/cymrufyw/hafan"}, "/cymrufyw/eisteddfod", "/cymrufyw/de-ddwyrain", "/cymrufyw/de-orllewin", "/cymrufyw/canolbarth", "/cymrufyw/gogledd-ddwyrain", "/cymrufyw/gogledd-orllewin", "/cymrufyw/gwleidyddiaeth", "/cymrufyw/cylchgrawn"]
      }
    }
  end
end
