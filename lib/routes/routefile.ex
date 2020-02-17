defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster

  redirect "/example/news/0", to: "/news", status: 302
  redirect "/example/weather/0", to: "/weather", status: 301

  handle "/", using: "HomePage", examples: ["/"]
  handle "/scotland", using: "ScotlandHomePage", examples: ["/scotland"]
  handle "/homepage/test", using: "TestHomePage", only_on: "test", examples: ["/homepage/test"]
  handle "/news", using: "NewsFrontPage", examples: ["/news"]
  handle "/sport", using: "SportFrontPage", examples: ["/sport"]
  handle "/weather", using: "WeatherFrontPage", examples: ["/weather"]
  handle "/bitesize", using: "BitesizeFrontPage", examples: ["/bitesize"]
  handle "/cbbc/search", using: "CbbcSearch", examples: ["/cbbc/search"]
  handle "/cbeebies", using: "CBeebiesFrontPage", examples: ["/cbeebies"]
  handle "/cbeebies/search", using: "CBeebiesSearch", examples: ["/cbeebies/search"]
  handle "/dynasties", using: "DynastiesFrontPage", examples: ["/dynasties"]

  handle "/wc-data/container/:name", using: "ContainerData", examples: ["/wc-data/container/promo-group"]
  handle "/wc-data/page-composition", using: "PageComposition", examples: ["/wc-data/page-composition?path=/sport"]
  handle "/hcraes", using: "Hcraes", examples: ["/hcraes"]

  handle "/news/beta/article/:id", using: "NewsArticlePage", examples: ["/news/beta/article/uk-politics-49336144"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/newsround/beta/article/:id", using: "NewsroundArticlePage", examples: ["/newsround/beta/article/49081103"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/sport/beta/article/:id", using: "SportArticlePage", examples: ["/sport/beta/article/rugby-union%2F49590345"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/news/search", using: "NewsSearch", examples: ["/news/search"]
  handle "/search", using: "Search", examples: ["/search"]

  handle "/news/videos/:id", using: "NewsVideos", examples: ["/news/videos/50653614"] do
    return_404 if: String.length(id) != 8
  end

  handle "/sport/videos/service-worker.js", using: "SportVideos", examples: ["/sport/videos/service-worker.js"]
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end

  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader", "/pres-test/hcraes"]

  handle "/tajik", using: "WorldServiceTajik", examples: ["/tajik"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik/news/2015/03/150331_l16_bbc-tajik_closure"]

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/topics/:id/:pageNumber", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt/1"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  existing_topic_ids = [
    "c7gj2g87ez8t",  # Alpine Skiing
    "c9em2e59y83t",  # Biathlon
    "c85z25g35kdt",  # Bobsleigh
    "c7gj2g8l8qdt",  # Cross Country Skiiing
    "c2yx2y7q8x0t",  # Curling
    "cv7dr79gjjet",  # Figure Skating
    "cmj5ljxk69yt",  # Freestyle Skiing
    "c2yx2y9qgr0t",  # Luge
    "c53gk34rmlkt",  # Nordic Combined
    "c0mz5mvjj09t",  # Short Track Skating
    "cezpvz7y3g6t",  # Skeleton
    "ck0r604dlrzt",  # Ski Jumping
    "cezpvzp93m5t",  # Snowboarding
    "c3dr5drg040t",  # Speed Skating
    "clmq6mqqdpqt",  # Rugby Sevens
  ]

  handle "/sport/:discipline", using: "TopicPage", examples: ["/sport/cpzrw9qgwelt"] do
    return_404 if: Enum.member?(existing_topic_ids, discipline)
  end

  handle "/sport/:discipline/:pageNumber", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt/1"] do
    return_404 if: Enum.member?(existing_topic_ids, discipline) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/sport/topics/:id", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/sport/topics/:id/:pageNumber", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt/1"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/web/shell", using: "WebShell", examples: ["/web/shell"]

  handle "/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"]
end
