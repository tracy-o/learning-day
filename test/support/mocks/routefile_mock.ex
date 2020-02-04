defmodule Routes.RoutefileMock do
  use BelfrageWeb.RouteMaster

  redirect("/permanent-redirect", to: "/new-location", status: 301)
  redirect("/temp-redirect", to: "/temp-location", status: 302)

  handle("/200-ok-reponse", using: "SomeLoop", examples: ["/200-ok-response"])

  handle("/downstream-not-found", using: "SomeLoop", examples: ["/downstream-not-found"])

  handle("/downstream-broken", using: "SomeLoop", examples: ["/downstream-broken"])

  handle "/premature-404", using: "SomeLoop", examples: ["/premature-404"] do
    return_404(if: true)
  end

  handle "/sends-request-downstream", using: "SomeLoop", examples: ["/sends-request-downstream"] do
    return_404(if: false)
  end

  handle("/only-on", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on"])

  handle("/*any", using: "SomeLoop", only_on: "test", examples: ["/foo/bar"])
end
