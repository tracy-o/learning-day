defmodule Routes.Specs.WelshNewSearch do
  def specs do
    %{
       platform: Webcore,
       default_language: "cy",
       query_params_allowlist: ["q", "page", "scope", "filter"]
     }
  end
end
