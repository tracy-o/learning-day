# this route file is compiled with matching "some_environment" production environment

defmodule Routes.RoutefileOnlyOnMock do
  use BelfrageWeb.RouteMaster

  handle("/only-on", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on"])

  handle("/only-on-with-block", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run")
  end

  no_match()
end
