defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster

  redirect("/example/news/0", to: "/news", status: 302)
  redirect("/example/weather/0", to: "/weather", status: 301)

  handle("/", using: "HomePage", examples: ["/"])
  handle("/news", using: "NewsFrontPage", examples: ["/news"])
  handle("/sport", using: "SportFrontPage", examples: ["/sport"])
  handle("/weather", using: "WeatherFrontPage", examples: ["/weather"])
  handle("/bitesize", using: "BitesizeFrontPage", examples: ["/bitesize"])
  handle("/cbeebies", using: "CBeebiesFrontPage", examples: ["/cbeebies"])
  handle("/dynasties", using: "DynastiesFrontPage", examples: ["/dynasties"])

  handle("/graphql", using: "Graphql", examples: ["/graphql"])

  handle "/news/beta/article/:id", using: "NewsArticlePage", examples: ["/news/beta/article/uk-politics-49336144"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/news/search", using: "NewsSearch", examples: ["/news/search"]
  handle "/search", using: "Search", examples: ["/search"]

  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404(if: String.length(id) != 8)
  end

  handle "/test/greeting-loader", using: "TestGreetingLoader", examples: ["/test/greeting-loader"]
  handle "/test/media-player", using: "TestMediaPlayer", examples: ["/test/media-player"]

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt"] do
    return_404(if: !String.match?(id, ~r/^c[\w]{10}t$/))
  end

  handle "/web/shell", using: "WebShell", examples: ["/web/shell"]

  handle("/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"])
end
