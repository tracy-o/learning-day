defmodule Routes.RoutefileMock do
  use BelfrageWeb.RouteMaster

  redirect("https://www.bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)
  redirect("https://bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)

  redirect("/permanent-redirect", to: "/new-location", status: 301)
  redirect("/temp-redirect", to: "/temp-location", status: 302)

  redirect("/rewrite-redirect/:id/media", to: "/new-location/:id/video", status: 302)
  redirect("/rewrite-redirect/:id/section", to: ["/new-location/section-", ":id", "/video"], status: 302)

  redirect("/redirect-with-path/*any", to: "/new-location-with-path/*any", status: 302)

  handle("/", using: "SomeLoop", examples: ["/"])

  handle("/fabl/:name", using: "SomeFablLoop", examples: ["/fabl/xray"])

  handle("/200-ok-response", using: "SomeLoop", examples: ["/200-ok-response"])

  handle("/downstream-not-found", using: "SomeLoop", examples: ["/downstream-not-found"])

  handle("/downstream-broken", using: "SomeLoop", examples: ["/downstream-broken"])

  handle "/premature-404", using: "SomeLoop", examples: ["/premature-404"] do
    return_404(if: true)
  end

  handle "/sends-request-downstream", using: "SomeLoop", examples: ["/sends-request-downstream"] do
    return_404(if: false)
  end

  handle("/only-on", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on"])

  handle("/moz", using: "Moz", examples: ["/moz"])

  handle("/com-to-uk-redirect", using: "SomeLoopComToUK", examples: ["/com-to-uk-redirect"])

  handle("/my/session", using: "MySession", examples: [])

  handle("/route-allow-headers", using: "SomeLoopAllowHeaders", examples: [])

  handle("/proxy-pass", using: "ProxyPass", examples: ["/proxy-pass"])

  handle_proxy_pass("/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"])

  no_match()
end
