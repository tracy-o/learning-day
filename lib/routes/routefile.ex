defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster

  handle "/news/topics/:id", using: "NewsTopics", examples: ["/news/topics/123"]
  handle "/news", using: "NewsFrontPage", examples: ["/news"]

  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/p077pnkr"] do
	return_404 if: String.length(id) != 8
  end

  handle "/*any", using: "ProxyPass", examples: ["/foo/bar"]
end
