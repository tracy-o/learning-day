defmodule Routes.Specs.BitesizeLegacy do
  @moduledoc """
  This RouteSpec is temporary. It exists because of a requirement in
  https://jira.dev.bbc.co.uk/browse/RESFRAME-4439 to have a RouteSpec which
  sends all of its traffic to morph router, to aid the migration of bitesize
  from morph router to webcore.
  """

  def specification do
    %{
      specs: %{
        owner: "bitesize-production@lists.forge.bbc.co.uk",
        platform: "MorphRouter",
        language_from_cookie: true,
        examples: [
          %{
            path: "/bitesize/levels",
            request_headers: %{"x-forwarded-host" => "www.bbc.co.uk"}
          },
          %{
            path: "/bitesize/guides/zcvy6yc/test.hybrid",
            request_headers: %{"x-forwarded-host" => "www.bbc.co.uk"}
          }
        ]
      }
    }
  end
end
