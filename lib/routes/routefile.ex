defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster

  redirect "/example/news/0", to: "/news", status: 302
  redirect "/example/weather/0", to: "/weather", status: 301

  handle "/", using: "HomePage", examples: ["/"]
  handle "/news", using: "NewsFrontPage", examples: ["/news"]
  handle "/sport", using: "SportFrontPage", examples: ["/sport"]
  handle "/weather", using: "WeatherFrontPage", examples: ["/weather"]
  handle "/bitesize", using: "BitesizeFrontPage", examples: ["/bitesize"]
  handle "/cbeebies", using: "CBeebiesFrontPage", examples: ["/cbeebies"]
  handle "/dynasties", using: "DynastiesFrontPage", examples: ["/dynasties"]

  handle "/graphql", using: "Graphql", examples: ["/graphql"]

  handle "/news/beta/article/:id", using: "ArticlePage", examples: ["/news/beta/article/uk-politics-49336144"] do
    return_404 if: String.length(id) < 1
  end
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/*any", using: "ProxyPass", examples: ["/foo/bar"] do
    return_404 if: Application.get_env(:belfrage, :production_environment) == "live"
  end
end
