# this route file is compiled with matching "some_environment" production environment

import BelfrageWeb.Routefile

defroutefile "RoutefileOnlyOnMock", "test" do
  handle("/only-on", using: "SomeRouteState", only_on: "test")

  handle "/only-on-with-block",
    using: "SomeRouteState",
    only_on: "test" do
    send_resp(conn, 200, "block run")
  end

  no_match()
end
