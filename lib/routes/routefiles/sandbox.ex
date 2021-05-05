defmodule Routes.Routefiles.Sandbox do
  use BelfrageWeb.RouteMaster

  handle "/news/election", using: "NewsElection", examples: []
end
