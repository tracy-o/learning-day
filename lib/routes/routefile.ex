defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster

  redirect "/news/0", to: "/news", status: 302
  redirect "/weather/0", to: "/weather", status: 301

  handle "/news", using: "NewsFrontPage", examples: ["/news"]
  handle "/sport", using: "SportFrontPage", examples: ["/sport"]
  handle "/weather", using: "WeatherFrontPage", examples: ["/weather"]
  handle "/bitesize", using: "BitesizeFrontPage", examples: ["/bitesize"]
  handle "/cbeebies", using: "CBeebiesFrontPage", examples: ["/cbeebies"]
  handle "/dynasties", using: "DynastiesFrontPage", examples: ["/dynasties"]

  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/p077pnkr"] do
    return_404 if: String.length(id) != 8
  end

  handle "/*any", using: "ProxyPass", examples: ["/foo/bar"]
end
