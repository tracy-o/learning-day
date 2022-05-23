req_headers = [
  {"x-bbc-edge-cache", "1"},
  {"x-bbc-edge-cdn", "1"},
  {"x-bbc-edge-country", "**"},
  {"x-bbc-edge-isuk", "yes"},
  {"x-country", "gb"},
  {"x-ip_is_uk_combined", "yes"},
  {"x-ip_is_advertise_combined", "yes"},
  {"replayed-traffic", "true"},
  {"origin-simulator", "true"},
  {"req-svc-chain", "SomeTrafficManager"},
  {"x-candy-audience", "1"},
  {"x-candy-override", "1"},
  {"x-candy-preview-guid", "1"},
  {"x-morph-env", "1"},
  {"x-use-fixture", "1"},
  {"cookie-ckps_language", "1"},
  {"cookie-ckps_chinese", "1"},
  {"cookie-ckps_serbian", "1"},
  {"origin", "https://www.test.bbc.co.uk"},
  {"referer", "https://www.test.bbc.co.uk/page"},
  {"user-agent", "MozartFetcher"}
]

Benchee.run(%{
  "slow" => fn -> BelfrageWeb.RequestHeaders.Mapper.slow_map(req_headers) end,
  "fast" => fn -> BelfrageWeb.RequestHeaders.Mapper.map(req_headers) end
})
