# this route file is compiled with non matching "some_other_environment" production environment

import BelfrageWeb.Routefile

defroutefile "RoutefileOnlyOnMultiEnvMock", "test" do
  handle("/only-on", using: "SomeRouteState", only_on: "some_environment")

  handle("/only-on-multi-env",
    using: "SomeRouteState",
    only_on: "some_environment"
  )

  handle("/only-on-multi-env", using: "SomeMozartRouteState")

  handle "/only-on-with-block",
    using: "SomeRouteState",
    only_on: "some_environment" do
    send_resp(conn, 200, "block run")
  end

  handle "/only-on-with-block-multi-env",
    using: "SomeRouteState",
    only_on: "some_environment" do
    send_resp(conn, 200, "block run")
  end

  handle "/only-on-with-block-multi-env",
    using: "SomeMozartRouteState" do
    send_resp(conn, 200, "block run from route_state on another env")
  end

  no_match()
end
