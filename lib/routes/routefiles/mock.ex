# this is  a copy of the test/support/mocks/routefile_mock.example
# TODO: define the best location

import BelfrageWeb.Routefile

defroutefile "Mock", "test" do
  redirect("https://www.bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)
  redirect("https://bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)

  redirect("/permanent-redirect", to: "/new-location", status: 301)
  redirect("/temp-redirect", to: "/temp-location", status: 302)

  redirect("/rewrite-redirect/:id", to: "/new-location/:id/somewhere", status: 302)
  redirect("/rewrite-redirect/:id.ext", to: "/new-location/:id/anywhere", status: 302)
  redirect("/rewrite-redirect/:id/:type/catch-all/*any", to: "/new-location/:type-:id/*any", status: 302)

  redirect("https://example.net/rewrite-redirect/:id/catch-all/*any",
    to: "https://bbc.com/new-location/:id-*any",
    status: 302
  )

  redirect("https://example.net/rewrite-redirect/:id/*any",
    to: "https://:id.bbc.com/new-location/*any",
    status: 302
  )

  redirect("/redirect-with-path.ext", to: "/new-location-with-path.ext", status: 302)
  redirect("/redirect-with-path/*any", to: "/new-location-with-path/*any", status: 302)
  redirect("/some/path/*any", to: "/another-path/*any", status: 301)
  redirect("/redirect-to-root", to: "/", status: 302)

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

  handle("/moz", using: "Moz", examples: ["/moz"])

  handle("/com-to-uk-redirect", using: "SomeLoopComToUK", examples: ["/com-to-uk-redirect"])

  handle("/my/session", using: "MySession", examples: [])

  handle("/my/session/webcore-platform", using: "MySessionWebcorePlatform", examples: [])

  handle("/route-allow-headers", using: "SomeLoopAllowHeaders", examples: [])

  handle("/format/rewrite/:discipline/av/:team.app", using: "SomeMozartLoop", examples: [])
  handle("/format/rewrite/:discipline/av/:team", using: "SomeLoop", examples: [])

  handle("/format/rewrite/:discipline.app", using: "SomeMozartLoop", examples: [])
  handle("/format/rewrite/:discipline", using: "SomeLoop", examples: [])
  handle("/format/rewrite/:discipline/av", using: "SomeLoop", examples: [])

  handle("/proxy-pass", using: "ProxyPass", examples: ["/proxy-pass"])

  handle("/personalisation-in-cascade", using: ["MySessionWebcorePlatform", "SomeMozartLoop"], examples: [])

  handle("/caching-disabled", using: "CacheDisabled", examples: [])

  handle_proxy_pass("/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"])

  no_match()
end
