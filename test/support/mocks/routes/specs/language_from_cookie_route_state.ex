defmodule Routes.Specs.LanguageFromCookieRouteState do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "Webcore",
        language_from_cookie: true
      }
    }
  end
end
