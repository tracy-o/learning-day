defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster
  alias Routes.Specs.TopicPage

  redirect "/example/news/0", to: "/news", status: 302
  redirect "/example/weather/0", to: "/weather", status: 301

  handle "/", using: "HomePage", examples: ["/"]
  handle "/scotland", using: "ScotlandHomePage", examples: ["/scotland"]
  handle "/homepage/test", using: "TestHomePage", only_on: "test", examples: ["/homepage/test"]
  handle "/news", using: "NewsFrontPage", examples: ["/news"]
  handle "/sport", using: "SportFrontPage", examples: ["/sport"]
  handle "/weather", using: "WeatherFrontPage", examples: ["/weather"]
  handle "/bitesize", using: "BitesizeFrontPage", examples: ["/bitesize"]
  handle "/cbeebies", using: "CBeebiesFrontPage", examples: ["/cbeebies"]
  handle "/dynasties", using: "DynastiesFrontPage", examples: ["/dynasties"]
  handle "/northernireland", using: "NorthernIrelandHomePage", examples: ["/northernireland"]
  handle "/wales", using: "WalesHomePage", examples: ["/wales"]

  handle "/fd/preview/:name", using: "FablData", examples: ["/fd/preview/example-module"]
  handle "/fd/:name", using: "FablData", examples: ["/fd/example-module"]

  handle "/wc-data/container/:name", using: "ContainerData", examples: ["/wc-data/container/promo-group"]
  handle "/wc-data/page-composition", using: "PageComposition", examples: ["/wc-data/page-composition?path=/sport"]
  handle "/hcraes", using: "Hcraes", examples: ["/hcraes"]

  handle "/mundo/noticias-51503412", using: "WorldServiceMundo", examples: ["/mundo/noticias-51503412"]
  handle "/mundo/components", using: "WorldServiceMundoComponent", examples: ["/mundo/components"]

  handle "/news/beta/article/:id", using: "NewsArticlePage", examples: ["/news/beta/article/uk-politics-49336144"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/newsround/beta/article/:id", using: "NewsroundArticlePage", examples: ["/newsround/beta/article/49081103"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/sport/beta/article/:id", using: "SportArticlePage", examples: ["/sport/beta/article/rugby-union%2F49590345"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/search", using: "Search", examples: ["/search"]
  handle "/chwilio", using: "Search", examples: ["/chwilio"]
  handle "/cbeebies/search", using: "Search", examples: ["/cbeebies/search"]
  handle "/cbbc/search", using: "Search", examples: ["/cbbc/search"]

  handle "/news/search", using: "NewsSearch", examples: ["/news/search"]
  handle "/news/videos/:id", using: "NewsVideos", examples: ["/news/videos/50653614"] do
    return_404 if: String.length(id) != 8
  end

  handle "/sport/videos/service-worker.js", using: "SportVideos", examples: ["/sport/videos/service-worker.js"]
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end

  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader", "/pres-test/hcraes"]

  handle "/igbo", using: "WorldServiceIgbo", examples: ["/igbo"]
  handle "/igbo/*_any", using: "WorldServiceIgbo", examples: ["/igbo/afirika-51708561"]

  handle "/pidgin", using: "WorldServicePidgin", examples: ["/pidgin"]
  handle "/pidgin/*_any", using: "WorldServicePidgin", examples: ["/pidgin/tori-51717056"]

  handle "/tajik", using: "WorldServiceTajik", examples: ["/tajik"]
  handle "/tajik/components", using: "WorldServiceTajikComponent", examples: ["/tajik/components"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik/news/2015/03/150331_l16_bbc-tajik_closure"]

  handle "/yoruba", using: "WorldServiceYoruba", examples: ["/yoruba"]
  handle "/yoruba/*_any", using: "WorldServiceYoruba", examples: ["/yoruba/awon-iroyin-miran-51716954"]

  handle "/topics/:id/:pageNumber", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt/1"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/sport/alpine-skiing.app", using: "SportPal", examples: ["/sport/alpine-skiing.app"]

  handle "/sport/topics/:id/:pageNumber", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt/1"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/sport/topics/:id", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/sport/:discipline/:pageNumber", using: "TopicPage", examples: ["/sport/snowboarding/1"] do
    return_404 if: !Enum.member?(TopicPage.sports_topics_routes, discipline) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/sport/:discipline", using: "TopicPage", examples: ["/sport/snowboarding"] do
    return_404 if: !Enum.member?(TopicPage.sports_topics_routes, discipline)
  end

  handle "/web/shell", using: "WebShell", examples: ["/web/shell"]

  handle "/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"]
end
