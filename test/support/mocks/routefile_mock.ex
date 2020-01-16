defmodule Routes.RoutefileMock do
  use BelfrageWeb.RouteMaster

  redirect("/permantent-redirect", to: "/new-location", status: 301)
  redirect("/temp-redirect", to: "/temp-location", status: 302)

  handle("/200-ok-reponse", using: "SomeLoop", examples: ["/200-ok-response"])

  handle("/downstream-not-found", using: "SomeLoop", examples: ["/downstream-not-found"])

  handle "/not-found", using: "SomeLoop", examples: ["/not-found"] do
    return_404(if: true)
  end

  handle("/only-on", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on"])

  handle("/*any", using: "SomeLoop", only_on: "test", examples: ["/foo/bar"])
end
