# this route file is compiled with non matching "some_other_environment" production environment

import BelfrageWeb.Routefile

defroutefile "RoutefileOnlyOnMultiEnvMock", "test" do
  handle("/only-on", using: "SomeRouteState", only_on: "some_environment", examples: ["/only-on"])

  handle("/only-on-multi-env", using: "SomeRouteState", only_on: "some_environment", examples: ["/only-on"])
  handle("/only-on-multi-env", using: "SomeMozartRouteState", examples: ["/only-on"])

  handle("/only-on-with-block", using: "SomeRouteState", only_on: "some_environment", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run")
  end

  handle("/only-on-with-block-multi-env",
    using: "SomeRouteState",
    only_on: "some_environment",
    examples: ["/only-on-with-block"]
  ) do
    send_resp(conn, 200, "block run")
  end

  handle("/only-on-with-block-multi-env", using: "SomeMozartRouteState", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run from loop on another env")
  end

  no_match()
end
