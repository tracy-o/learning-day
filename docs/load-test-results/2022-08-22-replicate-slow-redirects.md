# Replicating Slow Redirects
On Saturday 30th July 2022 we received a large spike of requests for the route '/vietnamese/' the trailing slash in this route led to it being redirected to '/vietnamese'.
This unexpectedly caused the internal latency metric 'Return Binary Response' to take as long as 309ms, much less that you would expect from a 301 with no body.

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-event-responses.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-event-simorgh-responses.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-event-cache-cpu.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-event-erlang-vm.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-event-cowboy.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-event-internal-latency-tooltip.png)

## Loadtest
RPS: 4000

Duration: 300 seconds

The load test client does not follow redirects

Each request is performed with a unique query string which is allowed by vietnamese ws routes.

load test
```
cat loadtest_no_follow_redirect && date && ./loadtest_no_follow_redirect
#!/usr/bin/env bash

d=300
r=4000
n=$(($d * $r))
(let i=0
while [ $i -lt $n ]; do
let i++
echo GET https://sally.belfrage.test.api.bbc.co.uk/vietnamese/?component_env=$i
done) | vegeta attack -header "x-bbc-edge-host:www.test.bbc.com" -header "replayed-traffic:true" -http2=false -max-body=0 -timeout=30s -redirects=-1  -rate=$r -duration=${d}s | tee vietnamese_300s_4000rps_querystring_results.bin | vegeta report
Tue  6 Sep 07:35:23 UTC 2022
Requests      [total, rate, throughput]  1081297, 3662.80, 1915.62
Duration      [total, attack, wait]      6m2.504984189s, 4m55.210425113s, 1m7.294559076s
Latencies     [mean, 50, 95, 99, max]    24.891259429s, 2.814909092s, 1m38.108436159s, 1m46.345227116s, 2m52.38298375s
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    64.22%
Status Codes  [code:count]               0:385308  301:694421  500:1568
Error Set:
Get https://sally.belfrage.test.api.bbc.co.uk/vietnamese/?component_env=62: net/http: request canceled (Client.Timeout exceeded while awaiting headers)
Get https://sally.belfrage.test.api.bbc.co.uk/vietnamese/?component_env=981: net/http: request canceled (Client.Timeout exceeded while awaiting headers)
...
```

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-responses.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-page-timings.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-os.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-2000rps-redirect-100-rps-200s-private-cpu.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-cache.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-erlang-vm.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-cowboy.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-internal-latency.png)

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-300s-4000rps-no-follow-redirects-internal-latency-tooltip.png)

This seems to replicate the incident accurately this can be seen by:
* 333ms 'Return Binary Response' internal latency (309ms in incident)
* Cache spike similar relative size and practically no cache hits
* CPU utilisation is similar
* Spikes in Erlang VM metrics (System Counts, VM run queue lengths, Cache locksmith queue length)

Using this load test format, this was analysed further using `observer_cli`.

![](./img/2022-08-22-replicate-slow-redirects/vietnamese-4000rps-300s-observer-cli.png)

You can see that `cache_locksmith` and `cache_stats` have a very high reduction count, high memory and often has a high message queue. For this reason I think this is the cause of the slowdown. I can't find the causal link but I think the checking of the cache for a response that isn't there is eating up the schedulers time.