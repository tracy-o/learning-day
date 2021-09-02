# this route file is compiled with non matching "some_other_environment" production environment

defmodule Routes.RoutefileOnlyOnMultiEnvMock do
  @production_environment "test"

  use BelfrageWeb.RouteMaster

  handle("/only-on", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on"])

  handle("/only-on-multi-env", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on"])
  handle("/only-on-multi-env", using: "SomeMozartLoop", examples: ["/only-on"])

  handle("/only-on-with-block", using: "SomeLoop", only_on: "some_environment", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run")
  end

  handle("/only-on-with-block-multi-env",
    using: "SomeLoop",
    only_on: "some_environment",
    examples: ["/only-on-with-block"]
  ) do
    send_resp(conn, 200, "block run")
  end

  handle("/only-on-with-block-multi-env", using: "SomeMozartLoop", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run from loop on another env")
  end

  no_match()
end
