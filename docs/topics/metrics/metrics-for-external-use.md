# Belfrage Metrics for other teams

Belfrage publishes a number of metrics to AWS CloudWatch that could be used by
other teams. The metrics are available in Belfrage's AWS accounts (there are
separate accounts for test and live).

Some of the metrics can be filtered by `route_spec` name to get numbers that
are relevant to specific route specs only.

## Metrics on Belfrage requests / responses

Here are the metrics that can be used to track requests that Belfrage receives
from downstream and responses that it sends:

* `belfrage.request.duration` - duration of requests to Belfrage with
  `status_code` (response status code) and associated `route_spec` name as
  dimensions.
* `belfrage.response` - number of responses from Belfrage with `status_code`
  (response status code) and associated `route_spec` name as dimensions.
* `belfrage.response.private` - number of responses with response status 200
  and 'cache-control: private' header from Belfrage with associated
  `route_spec` name as dimension.
* `belfrage.response.stale` - number of stale cached response from Belfrage
  with with associated `route_spec` name as dimension.
* `belfrage.error` - number of internal errors in Belfrage with associated
  `route_spec` name as dimension.

## Metrics on Webcore requests / responses

Here are the metrics that can be used to track requests that Belfrage makes to
Webcore (i.e. Pres lambda) and responses that it gets back:

* `webcore.request.count` - number of requests that Belfrage makes to Pres with
  associated `route_spec` name as dimension.
* `webcore.request.duration` - duration of requests that Belfrage makes to Pres
  with associated `route_spec` name as dimension.
* `webcore.response` - number of responses Belfrage gets back from Pres with
  `status_code` (response status code) and associated `route_spec` name as
  dimensions.
* `webcore.error` - number of errors that happen when Belfrage makes a request
  to Pres with `error_code` (a string) and associated `route_spec` name as
  dimensions.

Note that `webcore.request.count` metric indicates the number of requests that
Belfrage attempts to make. Not all of them will succeed and so generally
speaking `webcore.request.count` = `webcore.response` + `webcore.error`.

This is different to Belfrage request / response metrics as there is no
`belfrage.request.count`. This is for two reasons:

* Belfrage returns a response downstream, even if an error happens in Belfrage
  (the status code will be 500 in such case). This means that
  `belfrage.response` includes `belfrage.error` and also a 500 status code in
  `belfrage.response` can mean both an error received from upstream and an
  internal error in belfrage (`belfrage.error` only includes the latter).
* If a request is made to Belfrage, but it's unable to respond, then it won't
  be possible to attribute that request to a route spec because the logic that
  maps URLs to route specs would not have been invoked, so such metric would
  not be helpful for other teams.
