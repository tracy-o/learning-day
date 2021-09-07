# this route file is compiled with matching "some_environment" production environment

import BelfrageWeb.Routefile

defroutefile "RoutefileOnlyOnMock", "test" do
  handle("/only-on", using: "SomeLoop", only_on: "test", examples: ["/only-on"])

  handle("/only-on-with-block", using: "SomeLoop", only_on: "test", examples: ["/only-on-with-block"]) do
    send_resp(conn, 200, "block run")
  end

  no_match()
end
