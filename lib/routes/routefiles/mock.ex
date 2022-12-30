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

  handle "/", using: "SomeRouteState", platform: "Webcore", examples: ["/"]

  handle "/fabl/:name", using: "SomeFablRouteState", platform: "Fabl", examples: ["/fabl/xray"]

  handle "/200-ok-response", using: "SomeRouteState", platform: "Webcore", examples: ["/200-ok-response"]

  handle "/202-ok-response", using: "SomeClassicAppsRouteSpec", platform: "ClassicApps", examples: ["/202-ok-response"]

  handle "/downstream-not-found", using: "SomeRouteState", platform: "Webcore", examples: ["/downstream-not-found"]

  handle "/downstream-broken", using: "SomeRouteState", platform: "Webcore", examples: ["/downstream-broken"]

  handle "/premature-404", using: "SomeRouteState", platform: "Webcore", examples: ["/premature-404"] do
    return_404(if: true)
  end

  handle "/sends-request-downstream", using: "SomeRouteState", platform: "Webcore", examples: ["/sends-request-downstream"] do
    return_404(if: false)
  end

  handle "/moz", using: "Moz", platform: "MozartNews", examples: ["/moz"]

  handle "/com-to-uk-redirect", using: "SomeRouteStateComToUK", platform: "Webcore", examples: ["/com-to-uk-redirect"]

  handle "/my/session", using: "MySession", platform: "OriginSimulator", examples: []

  handle "/my/session/webcore-platform", using: "MySessionWebcorePlatform", platform: "Webcore", examples: []

  handle "/route-allow-headers", using: "SomeRouteStateAllowHeaders", platform: "Webcore", examples: []

  handle "/format/rewrite/:discipline/av/:team.app", using: "SomeMozartRouteState", platform: "MozartNews", examples: []
  handle "/format/rewrite/:discipline/av/:team", using: "SomeRouteState", platform: "Webcore", examples: []

  handle "/format/rewrite/:discipline.app", using: "SomeMozartRouteState", platform: "MozartNews", examples: []
  handle "/format/rewrite/:discipline", using: "SomeRouteState", platform: "Webcore", examples: []
  handle "/format/rewrite/:discipline/av", using: "SomeRouteState", platform: "Webcore", examples: []

  handle "/proxy-pass", using: "ProxyPass", platform: "OriginSimulator", examples: ["/proxy-pass"]

  handle "/caching-disabled", using: "CacheDisabled", platform: "Webcore", examples: []

  handle "/language-from-cookie", using: "LanguageFromCookieRouteState", platform: "Webcore", examples: []

  handle "/personalised-news-article-page", using: "PersonalisedContainerData", platform: "Webcore", examples: []

  handle "/mvt", using: "SomeMvtRouteState", platform: "Webcore", examples: ["/mvt"]

  handle "/ws-mvt", using: "SomeSimorghRouteSpec", platform: "Simorgh", examples: ["/ws-mvt"]

  handle "/proxy-on-joan/:id", using: "NewsArticlePage", platform: "Webcore", examples: ["/proxy-on-joan/49336140"]

  handle "/app-request/p/:name", using: "PersonalisedFablData", platform: "Fabl", examples: []

  handle "/app-request/:name", using: "FablData", platform: "Fabl", examples: []

  handle "/personalised-to-non-personalised", using: "PersonalisedToNonPersonalised", platform: "Webcore", examples: []

  # will remove and use real route spec in RESFRAME-4718
  handle "/classic-apps-route", using: "SomeClassicAppsRouteSpec", platform: "ClassicApps", examples: []

  handle "/sport/:discipline/rss.xml", using: "SportRssGuid", platform: "Karanga", examples: []

  handle "/content/ldp/:guid", using: "ClassicAppFablLdp", platform: "Fabl", examples: []

  handle "/etag-support", using: "EtagSupport", platform: "MozartNews", examples: []

  handle "/fd/abl", using: "AblDataWithNoCache", platform: "Fabl", examples: []

  handle "/no-etag-support", using: "NoEtagSupport", platform: "MozartNews", examples: []

  handle("/platform-selection-with-selector", using: "SomeRouteStateWithoutPlatformAttribute", platform: "AssetTypePlatformSelector", examples: [])

  handle("/platform-selection-with-webcore-platform", using: "SomeRouteStateWithoutPlatformAttribute", platform: "Webcore", examples: [])

  handle("/platform-selection-with-mozart-news-platform", using: "SomeRouteStateWithoutPlatformAttribute", platform: "MozartNews", examples: [])

  handle_proxy_pass "/*any", using: "ProxyPass", platform: "OriginSimulator", only_on: "test", examples: ["/foo/bar"]

  no_match()
end
