use Mix.Config

import_config "dev.exs"

config :belfrage,
  http_client: Belfrage.Clients.HTTPMock,
  lambda_client: Belfrage.Clients.LambdaMock,
  ccp_client: Belfrage.Clients.CCPMock,
  routefile: Routes.RoutefileMock,
  production_environment: "test"
