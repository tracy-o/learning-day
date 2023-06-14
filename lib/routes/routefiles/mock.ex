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

  handle "/", using: "SomeRouteState"

  handle "/fabl/:name", using: "SomeFablRouteState"

  handle "/200-ok-response", using: "SomeRouteState"

  handle "/202-ok-response", using: "SomeClassicAppsRouteSpec"

  handle "/downstream-not-found", using: "SomeRouteState"

  handle "/downstream-broken", using: "SomeRouteState"

  handle "/premature-404", using: "SomeRouteState" do
    return_404(if: true)
  end

  handle "/sends-request-downstream", using: "SomeRouteState" do
    return_404(if: false)
  end

  handle "/moz", using: "Moz"

  handle "/com-to-uk-redirect", using: "SomeRouteStateComToUK"

  handle "/my/session", using: "MySession"

  handle "/my/session/webcore-platform", using: "MySessionWebcorePlatform"

  handle "/route-allow-headers", using: "SomeRouteStateAllowHeaders"

  handle "/format/rewrite/:discipline/av/:team.app", using: "SomeMozartRouteState"
  handle "/format/rewrite/:discipline/av/:team", using: "SomeRouteState"

  handle "/format/rewrite/:discipline.app", using: "SomeMozartRouteState"
  handle "/format/rewrite/:discipline", using: "SomeRouteState"
  handle "/format/rewrite/:discipline/av", using: "SomeRouteState"

  handle "/some-webcore-bbcx-content", using: "SomeRouteState"
  handle "/some-mozart-bbcx-content", using: "SomeMozartRouteState"
  handle "/some-mozart-sport-bbcx-content", using: "SomeMozartSportRouteState"

  handle "/proxy-pass", using: "ProxyPass"

  handle "/caching-disabled", using: "CacheDisabled"

  handle "/language-from-cookie", using: "LanguageFromCookieRouteState"

  handle "/personalised-news-article-page", using: "PersonalisedContainerData"

  handle "/mvt", using: "SomeMvtRouteState"

  handle "/ws-mvt", using: "SomeSimorghRouteSpec"

  handle "/proxy-on-joan/:id", using: "NewsArticlePage"

  handle "/app-request/p/:name", using: "AppPersonalisation"
  handle "/app-request/:name", using: "FablData"

  handle "/personalised-to-non-personalised", using: "PersonalisedToNonPersonalised"

  # will remove and use real route spec in RESFRAME-4718
  handle "/classic-apps-route", using: "SomeClassicAppsRouteSpec"

  handle "/sport/:discipline/rss.xml", using: "SportRssGuid"

  handle "/content/ldp/:guid", using: "ClassicAppFablLdp"

  handle "/etag-support", using: "EtagSupport"

  handle "/fd/abl", using: "AblDataWithNoCache"

  handle "/no-etag-support", using: "NoEtagSupport"

  handle("/platform-selection-with-selector", using: "AssetTypeWithMultipleSpecs")

  handle("/platform-selection-with-webcore-platform", using: "SomeRouteStateWithMultipleSpecs")

  handle("/platform-selection-with-mozart-news-platform", using: "SomeRouteStateWithMultipleSpecs")

  handle "/election2023postcode/:postcode", using: "ElectoralCommissionPostcode" do
    return_404 if: !String.match?(postcode, ~r/^(GIR 0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKPS-UW]) *[0-9][ABD-HJLNP-UW-Z]{2})$/)
  end
  handle "/election2023address/:uprn", using: "ElectoralCommissionAddress" do
    return_404 if: !String.match?(uprn, ~r/^\d{6,12}$/)
  end

  handle "/sport/av/football/:id", using: "MySessionWebcorePlatform" do
    return_404 if: [
      !String.match?(id, ~r/\A[0-9]{4,9}\z/)
    ]
  end

  handle_proxy_pass "/*any", using: "ProxyPass", only_on: "test"

  no_match()
end
