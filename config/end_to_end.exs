use Mix.Config

import_config "dev.exs"

config :belfrage,
  http_client: Belfrage.Clients.HTTPMock,
  lambda_client: Belfrage.Clients.LambdaMock,
  ccp_client: Belfrage.Clients.CCPMock,
  authentication_client: Belfrage.Clients.AuthenticationMock,
  monitor_api: Belfrage.MonitorMock,
  production_environment: "test",
  dial: Belfrage.Dials.ServerMock,
  xray: Belfrage.XrayMock,
  jwk_polling_enabled: false,
  webcore_credentials_polling_enabled: false,

  # Arbitrary long values so that the corresponding operations are never
  # executed in tests
  bbc_id_availability_poll_interval: 3_600_000
