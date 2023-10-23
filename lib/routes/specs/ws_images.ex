defmodule Routes.Specs.WsImages do
  def specification(production_env) do
    %{
      specs: %{
        platform: "MozartSimorgh",
        query_params_allowlist: ["alternativeJsLoading", "batch"],
        examples: [%{expected_status: 301, path: "/worldservice/assets/images/2012/07/12/120712163431_img_0328.jpg"}]
      }
    }
  end
end
