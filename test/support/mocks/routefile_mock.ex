defmodule Routes.RoutefileMock do
  use BelfrageWeb.RouteMaster

  redirect "/permantent-redirect", to: "/new-location", status: 301
  redirect "/temp-redirect", to: "/temp-location", status: 302

  handle "/i-exist", using: "SomeLoop", examples: ["/"]

  handle "/downstream-not-found", using: "SomeLoop", examples: ["/"]

  handle "/not-found", using: "SomeLoop", examples: ["/"] do
    return_404(if: true)
  end

  handle "/*any", using: "SomeLoop", only_on: "test", examples: ["/foo/bar"]
end
