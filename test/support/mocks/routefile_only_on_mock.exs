# this route file is compiled with matching "some_environment" production environment

defmodule Routes.RoutefileOnlyOnMock do
  @production_environment "test"

  use BelfrageWeb.RouteMaster

  handle("/only-on", using: "SomeLoop", only_on: "test", examples: ["/only-on"])

  handle("/only-on-with-block", using: "SomeLoop", only_on: "test", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run")
  end

  no_match()
end
