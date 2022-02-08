# Testing Finch HTTP client
- 20-22 September 2021
- Belfrage test using Belfrage Playground, Origin Simulator and the Load Test instance
- No caching - all responses were cache control private
- Compressed content - all responses were content encoded as gzip
- Vegeta was used as the load test client
- Tests were run using http1

## Background
During previous load tests and some live scenarios we have seen errors in the logs relating to [Poolboy](https://github.com/devinus/poolboy). This is used by our [Machine Gun](https://github.com/petrohi/machine_gun) HTTP client to allow a pool of connections, allowing reuse to not open a new connection for each request.

We have seen issues around worker checkouts and when there are issues there is queuing inside Poolboy which seems workers are then unavailable.

There is another HTTP client called [Finch](https://github.com/keathley/finch) which is built for performance. It uses [NimblePool](https://github.com/dashbitco/nimble_pool) to manage the resources.

The idea is to compare previous Belfrage load tests with a branch using Finch to see if we get more performance out of Belfrage and do not run into the previous issues.

## Goals
We want to discover from these load tests:
- If there are any issues with Finch or NimblePool.
- How much load Belfrage is able to handle without pool issues.
- The performance of Belfrage using Finch compared to using Machine Gun.

## Method
Using the load test instance, playground and origin simulator we will test the Finch client in the Belfrage application.

From the load test instance the load test will fire requests at '/sam' with a predetemined requests per second rate.

## Config
### Load test Instance
- Instance Type - c5.9xlarge

### Playground
- Instance Type - c5.2xlarge

Using belfrage with the commit hash of:
```
13cfcc915f555f1762d8e7a09943b302af56a83d
```

### Origin Simulator
- Instance Type - c5.2xlarge

This is the origin simulator config:
```
{
    "origin": "https://www.bbc.co.uk/sport",
    "route": "/*",
    "stages": [{ "at": 0, "status": 200, "latency": "1s"}],
    "headers": {"content-encoding": "gzip"}
}
```

## Tests
### 1000 RPS 60 seconds 1 second latency 1024 workers

This test ran for 60 seconds but later tests run for 300 seconds.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 60s -rate 1000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  60000, 1000.02, 983.47
Duration      [total, attack, wait]      1m1.008756513s, 59.998998532s, 1.009757981s
Latencies     [mean, 50, 95, 99, max]    1.010182842s, 1.010181781s, 1.012485546s, 1.013584483s, 1.026261116s
Bytes In      [total, mean]              34451760000, 574196.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:60000
Error Set:
```

### 2000 RPS 60 seconds 1 second latency 1024 workers

This test ran for 60 seconds but later tests run for 300 seconds.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 60s -rate 2000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  120000, 2000.01, 1008.77
Duration      [total, attack, wait]      1m5.976216605s, 59.999554074s, 5.976662531s
Latencies     [mean, 50, 95, 99, max]    5.321448251s, 5.044120078s, 6.02004288s, 6.124944155s, 6.584765029s
Bytes In      [total, mean]              38218393920, 318486.62
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    55.46%
Status Codes  [code:count]               200:66555  500:53445
Error Set:
500 Internal Server Error
```

### 1500 RPS 60 seconds 1 second latency 1024 workers

This test ran for 60 seconds but later tests run for 300 seconds.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 60s -rate 1500 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  90000, 1500.02, 1010.72
Duration      [total, attack, wait]      1m5.854282949s, 59.999257978s, 5.855024971s
Latencies     [mean, 50, 95, 99, max]    5.263330254s, 5.974519961s, 6.004205007s, 6.012374943s, 6.056348365s
Bytes In      [total, mean]              38219704640, 424663.38
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    73.96%
Status Codes  [code:count]               200:66560  500:23440
Error Set:
500 Internal Server Error
```

Errors seen during the 1500 and the 2000 rps load tests.
```
Server: 10.114.172.57:7080 (http)
Request: GET /sam
** (exit) exited in: NimblePool.checkout(#PID<0.4106.0>)
    ** (EXIT) time out
{"datetime":"2021-09-20T10:09:29.260902Z","kind":"exit","level":"error","metadata":{"loop_id":"ProxyPass","path":"/sam","request_id":"009f9834ef444e17a574664f73c92274"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["Elixir.NimblePool","checkout",["#Pid<>"]]],"request_path":"/sam","stack":"    (finch 0.8.2) lib/finch/http1/pool.ex:58: Finch.HTTP1.Pool.request/5\n    (finch 0.8.2) lib/finch.ex:261: Finch.request/3\n    (belfrage 0.2.0) lib/belfrage/clients/http.ex:22: Belfrage.Clients.HTTP.execute/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:114: Belfrage.Services.HTTP.execute_request/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:19: Belfrage.Services.HTTP.dispatch/1\n    (belfrage 0.2.0) lib/belfrage.ex:40: Belfrage.generate_response/1\n    (belfrage 0.2.0) lib/belfrage_web/route_master.ex:28: BelfrageWeb.RouteMaster.yield/2\n    (belfrage 0.2.0) lib/plug/router.ex:284: Routes.Routefiles.Test.dispatch/2\n"}
#PID<0.32734.46> running BelfrageWeb.Router (connection #PID<0.9406.35>, stream id 10) terminated
Server: 10.114.172.57:7080 (http)
Request: GET /sam
** (exit) exited in: NimblePool.checkout(#PID<0.4106.0>)
    ** (EXIT) time out
{"datetime":"2021-09-20T10:09:29.261675Z","kind":"exit","level":"error","metadata":{"loop_id":"ProxyPass","path":"/sam","request_id":"290fff76558f49bcaf1617cb4befd059"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["Elixir.NimblePool","checkout",["#Pid<>"]]],"request_path":"/sam","stack":"    (finch 0.8.2) lib/finch/http1/pool.ex:58: Finch.HTTP1.Pool.request/5\n    (finch 0.8.2) lib/finch.ex:261: Finch.request/3\n    (belfrage 0.2.0) lib/belfrage/clients/http.ex:22: Belfrage.Clients.HTTP.execute/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:114: Belfrage.Services.HTTP.execute_request/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:19: Belfrage.Services.HTTP.dispatch/1\n    (belfrage 0.2.0) lib/belfrage.ex:40: Belfrage.generate_response/1\n    (belfrage 0.2.0) lib/belfrage_web/route_master.ex:28: BelfrageWeb.RouteMaster.yield/2\n    (belfrage 0.2.0) lib/plug/router.ex:284: Routes.Routefiles.Test.dispatch/2\n"}
{"datetime":"2021-09-20T10:09:29.261848Z","kind":"exit","level":"error","metadata":{"loop_id":"ProxyPass","path":"/sam","request_id":"4dc9f6a88c4a4566b9c5f42f2cca2f4c"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["Elixir.NimblePool","checkout",["#Pid<>"]]],"request_path":"/sam","stack":"    (finch 0.8.2) lib/finch/http1/pool.ex:58: Finch.HTTP1.Pool.request/5\n    (finch 0.8.2) lib/finch.ex:261: Finch.request/3\n    (belfrage 0.2.0) lib/belfrage/clients/http.ex:22: Belfrage.Clients.HTTP.execute/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:114: Belfrage.Services.HTTP.execute_request/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:19: Belfrage.Services.HTTP.dispatch/1\n    (belfrage 0.2.0) lib/belfrage.ex:40: Belfrage.generate_response/1\n    (belfrage 0.2.0) lib/belfrage_web/route_master.ex:28: BelfrageWeb.RouteMaster.yield/2\n    (belfrage 0.2.0) lib/plug/router.ex:284: Routes.Routefiles.Test.dispatch/2\n"}
#PID<0.32748.46> running BelfrageWeb.Router (connection #PID<0.1496.32>, stream id 10) terminated
Server: 10.114.172.57:7080 (http)
```

### 1000 RPS 300 seconds 1 second latency 1024 workers

The free CPU in Belfrage went down to 31% free.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 1000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  299999, 999.99, 996.65
Duration      [total, attack, wait]      5m1.008056287s, 5m0.000542325s, 1.007513962s
Latencies     [mean, 50, 95, 99, max]    1.010230472s, 1.010229616s, 1.012477767s, 1.013437797s, 1.025399118s
Bytes In      [total, mean]              172258225804, 574196.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:299999
Error Set:
```

### 2000 RPS 60 seconds 1 second latency 2048 workers

This test ran for 60 seconds but later tests run for 300 seconds.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 60s -rate 2000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  120000, 2000.02, 1966.75
Duration      [total, attack, wait]      1m1.014453454s, 59.999536455s, 1.014916999s
Latencies     [mean, 50, 95, 99, max]    1.018612273s, 1.013501827s, 1.050051422s, 1.117206705s, 1.431462443s
Bytes In      [total, mean]              68903520000, 574196.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:120000
Error Set:
```

### 2000 RPS 300 seconds 1 second latency 2048 workers

This test ran for 300 seconds. The free CPU in Belfrage went down to 17%.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 2000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  600000, 2000.00, 1992.73
Duration      [total, attack, wait]      5m1.094846353s, 4m59.999596995s, 1.095249358s
Latencies     [mean, 50, 95, 99, max]    1.025327574s, 1.013943123s, 1.087865464s, 1.249491637s, 4.511041205s
Bytes In      [total, mean]              344517600000, 574196.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:600000
Error Set:
```

### 3000 RPS 300 seconds 1 second latency 3072 workers

We had nimble pool errors in Belfrage logs.
```
{"datetime":"2021-09-20T09:57:48.625040Z","kind":"exit","level":"error","metadata":{"loop_id":"ProxyPass","path":"/sam","request_id":"79337ab48daf44dcbc08602014e727b3"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["Elixir.NimblePool","checkout",["#Pid<>"]]],"request_path":"/sam","stack":"    (finch 0.8.2) lib/finch/http1/pool.ex:58: Finch.HTTP1.Pool.request/5\n    (finch 0.8.2) lib/finch.ex:261: Finch.request/3\n    (belfrage 0.2.0) lib/belfrage/clients/http.ex:22: Belfrage.Clients.HTTP.execute/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:114: Belfrage.Services.HTTP.execute_request/2\n    (belfrage 0.2.0) lib/belfrage/services/http.ex:19: Belfrage.Services.HTTP.dispatch/1\n    (belfrage 0.2.0) lib/belfrage.ex:40: Belfrage.generate_response/1\n    (belfrage 0.2.0) lib/belfrage_web/route_master.ex:28: BelfrageWeb.RouteMaster.yield/2\n    (belfrage 0.2.0) lib/plug/router.ex:284: Routes.Routefiles.Test.dispatch/2\n"}
#PID<0.18823.31> running BelfrageWeb.Router (connection #PID<0.21882.14>, stream id 11) terminated
Server: 10.114.172.57:7080 (http)
Request: GET /sam
** (exit) exited in: NimblePool.checkout(#PID<0.4106.0>)
    ** (EXIT) time out
#PID<0.18828.31> running BelfrageWeb.Router (connection #PID<0.26783.14>, stream id 11) terminated
Server: 10.114.172.57:7080 (http)
Request: GET /sam
** (exit) exited in: NimblePool.checkout(#PID<0.4106.0>)
    ** (EXIT) time out
```

### 3000 RPS 300 seconds 1 second latency 3072 workers and pool count 8

We had nimble pool errors with 1 pool count. After changing to 8 we had a different Belfrage error.

```
Task #PID<0.30619.6> started from #PID<0.28198.6> terminating
** (stop) exited in: GenServer.call({:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, "ProxyPass"}}}, :state, 250)
    ** (EXIT) time out
    (belfrage 0.2.0) lib/belfrage/loop.ex:18: Belfrage.Loop.state/2
    (belfrage 0.2.0) lib/belfrage/processor.ex:23: Belfrage.Processor.get_loop/1
    (belfrage 0.2.0) lib/belfrage.ex:22: Belfrage.prepare_request/1
    (belfrage 0.2.0) lib/belfrage.ex:13: anonymous fn/1 in Belfrage.handle/1
    (elixir 1.11.3) lib/task/supervised.ex:90: Task.Supervised.invoke_mfa/2
    (elixir 1.11.3) lib/task/supervised.ex:35: Task.Supervised.reply/5
    (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Function: &:erlang.apply/2
    Args: [#Function<1.130814865/1 in Belfrage.Concurrently.run/2>, [%Belfrage.Struct{debug: %Belfrage.Struct.Debug{pipeline_trail: []}, private: %Belfrage.Struct.Private{candidate_loop_ids: ["ProxyPass"], circuit_breaker_error_threshold: nil, cookie_allowlist: [], counter: %{}, default_language: "en-GB", fallback_ttl: 21600000, features: %{}, headers_allowlist: [], long_counter: %{}, loop_id: "ProxyPass", origin: nil, overrides: %{}, owner: nil, personalised_request: false, personalised_route: false, pipeline: [], platform: nil, preview_mode: "on", production_environment: "test", query_params_allowlist: [], runbook: nil, signature_keys: %{add: [], skip: []}}, request: #Belfrage.Struct.Request<accept_encoding: "gzip", cdn?: false, cookie_ckps_chinese: nil, cookie_ckps_language: nil, cookie_ckps_serbian: nil, country: "gb", edge_cache?: false, has_been_replayed?: nil, host: "10.114.172.57:7080", is_advertise: false, is_uk: false, language: nil, method: "GET", origin: nil, origin_simulator?: true, path: "/sam", path_params: %{"any" => ["sam"]}, payload: "", query_params: %{}, referer: nil, req_svc_chain: "BELFRAGE", request_hash: nil, request_id: "03c553f60deb4a36badf8bbf1e965d89", scheme: :https, subdomain: "10", user_agent: "Go-http-client/1.1", x_candy_audience: nil, x_candy_override: nil, x_candy_preview_guid: nil, x_morph_env: nil, x_use_fixture: nil, xray_trace_id: "Root=1-6148691c-ff50e75836a8b45a268078f2;Parent=dc96d769a3a2ef6b;Sampled=0", ...>, response: %Belfrage.Struct.Response{body: "", cache_directive: %Belfrage.CacheControl{cacheability: "private", max_age: nil, stale_if_error: nil, stale_while_revalidate: nil}, cache_last_updated: nil, fallback: false, headers: %{}, http_status: nil}, user_session: #Belfrage.Struct.UserSession<authenticated: false, authentication_env: nil, valid_session: false, ...>}]]
```

### 2000 RPS 300 seconds 1 second latency 2048 workers and pool count 8

The free CPU in Belfrage went down to 17%.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 2000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  600000, 2000.00, 1993.28
Duration      [total, attack, wait]      5m1.011212783s, 4m59.999534592s, 1.011678191s
Latencies     [mean, 50, 95, 99, max]    1.015533556s, 1.012970495s, 1.024359316s, 1.076933611s, 1.487024934s
Bytes In      [total, mean]              344517600000, 574196.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:600000
Error Set:
```

### 3000 RPS 300 seconds 100 ms latency 3072 workers and pool count 8

The CPU went to 4% free.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 3000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  900001, 3000.01, 2977.94
Duration      [total, attack, wait]      5m0.545521067s, 4m59.99974853s, 545.772537ms
Latencies     [mean, 50, 95, 99, max]    791.514749ms, 704.175018ms, 1.265219089s, 1.870347719s, 21.163031759s
Bytes In      [total, mean]              438853799368, 487614.79
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    99.45%
Status Codes  [code:count]               0:26  200:895008  500:4967
Error Set:
500 Internal Server Error
Get http://10.114.172.57:7080/sam: EOF
```

We saw these errors in the Belfrage logs.
```
Task #PID<0.32580.138> started from #PID<0.11838.139> terminating
** (stop) exited in: GenServer.call({:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, "ProxyPass"}}}, :state, 250)
    ** (EXIT) time out
    (belfrage 0.2.0) lib/belfrage/loop.ex:18: Belfrage.Loop.state/2
    (belfrage 0.2.0) lib/belfrage/processor.ex:23: Belfrage.Processor.get_loop/1
    (belfrage 0.2.0) lib/belfrage.ex:22: Belfrage.prepare_request/1
    (belfrage 0.2.0) lib/belfrage.ex:13: anonymous fn/1 in Belfrage.handle/1
    (elixir 1.11.3) lib/task/supervised.ex:90: Task.Supervised.invoke_mfa/2
    (elixir 1.11.3) lib/task/supervised.ex:35: Task.Supervised.reply/5
    (stdlib 3.14) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Function: &:erlang.apply/2
    Args: [#Function<1.130814865/1 in Belfrage.Concurrently.run/2>, [%Belfrage.Struct{debug: %Belfrage.Struct.Debug{pipeline_trail: []}, private: %Belfrage.Struct.Private{candidate_loop_ids: ["ProxyPass"], circuit_breaker_error_threshold: nil, cookie_allowlist: [], counter: %{}, default_language: "en-GB", fallback_ttl: 21600000, features: %{}, headers_allowlist: [], long_counter: %{}, loop_id: "ProxyPass", origin: nil, overrides: %{}, owner: nil, personalised_request: false, personalised_route: false, pipeline: [], platform: nil, preview_mode: "on", production_environment: "test", query_params_allowlist: [], runbook: nil, signature_keys: %{add: [], skip: []}}, request: #Belfrage.Struct.Request<accept_encoding: "gzip", cdn?: false, cookie_ckps_chinese: nil, cookie_ckps_language: nil, cookie_ckps_serbian: nil, country: "gb", edge_cache?: false, has_been_replayed?: nil, host: "10.114.172.57:7080", is_advertise: false, is_uk: false, language: nil, method: "GET", origin: nil, origin_simulator?: true, path: "/sam", path_params: %{"any" => ["sam"]}, payload: "", query_params: %{}, referer: nil, req_svc_chain: "BELFRAGE", request_hash: nil, request_id: "9d6493a1b7064866aaf800d31c3f7f28", scheme: :https, subdomain: "10", user_agent: "Go-http-client/1.1", x_candy_audience: nil, x_candy_override: nil, x_candy_preview_guid: nil, x_morph_env: nil, x_use_fixture: nil, xray_trace_id: "Root=1-61486df3-ba486a2e162ffb854c1dd5d8;Parent=228219ffabe6cef6;Sampled=0", ...>, response: %Belfrage.Struct.Response{body: "", cache_directive: %Belfrage.CacheControl{cacheability: "private", max_age: nil, stale_if_error: nil, stale_while_revalidate: nil}, cache_last_updated: nil, fallback: false, headers: %{}, http_status: nil}, user_session: #Belfrage.Struct.UserSession<authenticated: false, authentication_env: nil, valid_session: false, ...>}]]
Ranch protocol #PID<0.26658.137> of listener BelfrageWeb.Router.HTTP (connection #PID<0.20983.120>, stream id 33) terminated
exited in: GenServer.call({:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, "ProxyPass"}}}, :state, 250)
    ** (EXIT) time out
```

### 3000 RPS 300 seconds 100 ms latency 3072 workers and pool count 8 and loop bypass

For this test we removed the loop lookup due to the previous error. All subsequent load tests have this code change.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 3000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  242167, 2950.75, 2747.73
Duration      [total, attack, wait]      1m28.075865674s, 1m22.069585913s, 6.006279761s
Latencies     [mean, 50, 95, 99, max]    3.033060824s, 2.499421362s, 7.151100902s, 9.248289162s, 20.585771479s
Bytes In      [total, mean]              118665483015, 490015.08
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    99.93%
Status Codes  [code:count]               0:158  200:242009
Error Set:
Get http://10.114.163.61:7080/sam: read tcp 10.114.168.111:3389->10.114.163.61:7080: read: connection reset by peer
Get http://10.114.163.61:7080/sam: read tcp 10.114.168.111:33437->10.114.163.61:7080: read: connection reset by peer
Get http://10.114.163.61:7080/sam: read tcp 10.114.168.111:59540->10.114.163.61:7080: read: connection reset by peer
Get http://10.114.163.61:7080/sam: EOF
```

### 3000 RPS 300 seconds 100 ms latency 3072 workers and pool count 8 and load test client using c5n.9xlarge

This is the same load test as the previous with the loop lookup removed. For this the load test instance was upgraded to a c5n.9xlarge.

The latency monitor in Belfrage has a high queue.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 3000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  900001, 3000.01, 2997.46
Duration      [total, attack, wait]      5m0.254596795s, 4m59.999741827s, 254.854968ms
Latencies     [mean, 50, 95, 99, max]    528.464861ms, 475.484009ms, 997.483168ms, 1.34525707s, 7.003494937s
Bytes In      [total, mean]              441301990335, 490335.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:900001
Error Set:
```

### 3000 RPS 300 seconds 100 ms latency 3072 workers and pool count 8 and latency monitor disabled

This is the same load test as the previous with the c5n.9xlarge load test instance. For this the latency monitor in Belfrage was disabled.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 3000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  900001, 3000.01, 2998.29
Duration      [total, attack, wait]      5m0.171025638s, 4m59.999747552s, 171.278086ms
Latencies     [mean, 50, 95, 99, max]    289.398591ms, 264.507794ms, 497.92225ms, 661.613638ms, 1.14053607s
Bytes In      [total, mean]              441301990335, 490335.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:900001
Error Set:
```

### 3000 RPS 300 seconds 100 ms latency 3072 workers and pool count 8 and Belfrage using c5n.2xlarge

This is the same load test as the previous with the latency monitor disabled. For this Belfrage was upgraded to a c5n.2xlarge.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 3000 -header "origin-simulator:true" -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  900001, 3000.01, 2998.22
Duration      [total, attack, wait]      5m0.178152863s, 4m59.999762047s, 178.390816ms
Latencies     [mean, 50, 95, 99, max]    305.404004ms, 289.386574ms, 475.863715ms, 577.02111ms, 907.574606ms
Bytes In      [total, mean]              441301990335, 490335.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:900001
Error Set:
```

### 4000 RPS 300 seconds 100 ms latency 4096 workers and pool count 8 and Belfrage using c5.2xlarge and load test client using c5.9xlarge

This is the same as the previous load tests with the latency monitor disabled. For this Belfrage was using a c5.2xlarge and the load test client was using a c5.9xlarge. The "max-body" property in the load tests from this one onwards was set to "0" to not store any bytes of the body.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 4000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1199991, 3999.82, 2429.29
Duration      [total, attack, wait]      5m25.950136338s, 5m0.011440878s, 25.93869546s
Latencies     [mean, 50, 95, 99, max]    24.54107057s, 23.188270003s, 58.194686889s, 1m6.091028071s, 2m14.245041894s
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    65.99%
Status Codes  [code:count]               0:406018  200:791829  500:2144
Error Set:
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:41865->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:56707->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:48891->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:2287->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.166.67:12621->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.166.67:36424->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.166.67:62550->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.166.67:43127->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
```

Belfrage had an error in the logs.
```
Server: 10.114.167.194:7080 (http)
Request: GET /sam
** (exit) exited in: :gen_server.call(:aws_ex_store_pool, {:checkout, #Reference<0.4201727879.4197974020.182954>, true}, 5000)
    ** (EXIT) time out
{"datetime":"2021-09-22T07:17:18.671042Z","kind":"exit","level":"error","metadata":{"request_id":"648198ee846844d3bfbf3482c2f11681"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["gen_server","call",["aws_ex_store_pool",["checkout","#Ref<>",true],5000]]],"request_path":"/sam","stack":"    (stdlib 3.14) gen_server.erl:246: :gen_server.call/3\n    (poolboy 1.5.2) /home/sam_french/belfrage/deps/poolboy/src/poolboy.erl:63: :poolboy.checkout/3\n    (poolboy 1.5.2) /home/sam_french/belfrage/deps/poolboy/src/poolboy.erl:82: :poolboy.transaction/3\n    (aws_ex_ray 0.1.16) lib/aws_ex_ray/store/monitor_supervisor.ex:17: AwsExRay.Store.MonitorSupervisor.start_monitoring/1\n    (aws_ex_ray 0.1.16) lib/aws_ex_ray.ex:258: AwsExRay.start_tracing/2\n    (belfrage 0.2.0) lib/belfrage_web/plugs/xray.ex:23: BelfrageWeb.Plugs.XRay.call/2\n    (belfrage 0.2.0) lib/belfrage_web/router.ex:1: BelfrageWeb.Router.plug_builder_call/2\n    (belfrage 0.2.0) lib/plug/error_handler.ex:65: BelfrageWeb.Router.call/2\n"}
{"datetime":"2021-09-22T07:17:18.671165Z","kind":"exit","level":"error","metadata":{"request_id":"d3164dbe2a114f0384c9af80b3287e6d"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["gen_server","call",["aws_ex_store_pool",["checkout","#Ref<>",true],5000]]],"request_path":"/sam","stack":"    (stdlib 3.14) gen_server.erl:246: :gen_server.call/3\n    (poolboy 1.5.2) /home/sam_french/belfrage/deps/poolboy/src/poolboy.erl:63: :poolboy.checkout/3\n    (poolboy 1.5.2) /home/sam_french/belfrage/deps/poolboy/src/poolboy.erl:82: :poolboy.transaction/3\n    (aws_ex_ray 0.1.16) lib/aws_ex_ray/store/monitor_supervisor.ex:17: AwsExRay.Store.MonitorSupervisor.start_monitoring/1\n    (aws_ex_ray 0.1.16) lib/aws_ex_ray.ex:258: AwsExRay.start_tracing/2\n    (belfrage 0.2.0) lib/belfrage_web/plugs/xray.ex:23: BelfrageWeb.Plugs.XRay.call/2\n    (belfrage 0.2.0) lib/belfrage_web/router.ex:1: BelfrageWeb.Router.plug_builder_call/2\n    (belfrage 0.2.0) lib/plug/error_handler.ex:65: BelfrageWeb.Router.call/2\n"}
#PID<0.17909.18> running BelfrageWeb.Router (connection #PID<0.16252.9>, stream id 5) terminated
```

### 4000 RPS 300 seconds 100 ms latency 4096 workers and pool count 8 and xray disabled

This is the same as the previous load test. For this xray was disabled by adding the path to the skip list.

Belfrage had this error in the logs.
```
{"datetime":"2021-09-22T07:28:41.353173Z","kind":"error","level":"error","metadata":{"path":"/sam","request_id":"1f49b27e947642829b33117c4fb6467a"},"msg":"Router Service returned a 500 status","query_string":"","reason":{"__exception__":true,"args":null,"arity":2,"clauses":null,"function":"adapt","kind":null,"module":"Elixir.BelfrageWeb.StructAdapter"},"request_path":"/sam","stack":"    (belfrage 0.2.0) lib/belfrage_web/struct_adapter.ex:7: BelfrageWeb.StructAdapter.adapt(%Plug.Conn{adapter: {Plug.Cowboy.Conn, :...}, assigns: %{}, before_send: [#Function<0.20869445/1 in BelfrageWeb.Plugs.AccessLogs.\"-fun.write_access_log/1-\">, #Function<0.100067019/1 in BelfrageWeb.Plugs.ResponseMetrics.call/2>, #Function<0.7691265/1 in BelfrageWeb.Plugs.LatencyMonitor.call/2>], body_params: %Plug.Conn.Unfetched{aspect: :body_params}, cookies: %Plug.Conn.Unfetched{aspect: :cookies}, halted: false, host: \"10.114.167.194\", method: \"GET\", owner: #PID<0.18191.1>, params: %{\"any\" => [\"sam\"]}, path_info: [\"sam\"], path_params: %{\"any\" => [\"sam\"]}, port: 7080, private: %{bbc_headers: %{cache: false, cdn: false, cookie_ckps_chinese: nil, cookie_ckps_language: nil, cookie_ckps_serbian: nil, country: \"gb\", host: \"10.114.167.194:7080\", is_advertise: false, is_uk: false, origin: nil, origin_simulator: true, referer: nil, replayed_traffic: nil, req_svc_chain: \"BELFRAGE\", scheme: :https, user_agent: \"Go-http-client/1.1\", x_candy_audience: nil, x_candy_override: nil, x_candy_preview_guid: nil, x_morph_env: nil, x_use_fixture: nil}, overrides: %{}, plug_route: {\"/*_path/*any\", #Function<1967.82447182/2 in Routes.Routefiles.Test.do_match/4>}, preview_mode: \"on\", production_environment: \"test\", request_id: \"1f49b27e947642829b33117c4fb6467a\"}, query_params: %{}, query_string: \"\", remote_ip: {10, 114, 166, 67}, req_cookies: %Plug.Conn.Unfetched{aspect: :cookies}, req_headers: [{\"accept-encoding\", \"gzip\"}, {\"host\", \"10.114.167.194:7080\"}, {\"origin-simulator\", \"true\"}, {\"user-agent\", \"Go-http-client/1.1\"}], request_path: \"/sam\", resp_body: nil, resp_cookies: %{}, resp_headers: [{\"cache-control\", \"max-age=0, private, must-revalidate\"}], scheme: :http, script_name: [], secret_key_base: nil, state: :unset, status: nil}, \"ProxyPass\")\n    (belfrage 0.2.0) lib/belfrage_web/route_master.ex:27: BelfrageWeb.RouteMaster.yield/2\n    (belfrage 0.2.0) lib/plug/router.ex:284: Routes.Routefiles.Test.dispatch/2\n    (belfrage 0.2.0) lib/routes/routefiles/main.ex:10: Routes.Routefiles.Test.plug_builder_call/2\n    (belfrage 0.2.0) lib/plug/router.ex:284: BelfrageWeb.Router.dispatch/2\n    (belfrage 0.2.0) lib/belfrage_web/router.ex:1: BelfrageWeb.Router.plug_builder_call/2\n    (belfrage 0.2.0) lib/plug/error_handler.ex:65: BelfrageWeb.Router.call/2\n    (plug_cowboy 2.5.0) lib/plug/cowboy/handler.ex:12: Plug.Cowboy.Handler.init/2\n"}
```

### 4000 RPS 300 seconds 100 ms latency 4096 workers and pool count 8 and xray trace id optional

This is the same as the previous load test with xray disabled. For this the "xray_trace_id" was made optional.

The free CPU in Belfrage went down to 7%.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 4000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1199985, 3999.86, 2604.75
Duration      [total, attack, wait]      5m26.730970436s, 5m0.00677769s, 26.724192746s
Latencies     [mean, 50, 95, 99, max]    19.303249919s, 16.420339236s, 50.094852661s, 53.435895035s, 1m57.208077606s
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    70.92%
Status Codes  [code:count]               0:348933  200:851052
Error Set:
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:6514->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:52219->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:58862->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.166.67:12472->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: dial tcp 0.0.0.0:0->10.114.167.194:7080: bind: address already in use
Get http://10.114.167.194:7080/sam: EOF
Get http://10.114.167.194:7080/sam: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.166.67:43938->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.166.67:62098->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
```

### 4000 RPS 300 seconds 100 ms latency 4096 workers and pool count 8 and load test client using c5n.9xlarge

This is the same as the previous load test with "xray_trace_id" optional. For this the load test client was using a c5n.9xlarge.

The free CPU in Belfrage went down to 6%.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 4000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1199503, 3998.20, 2603.65
Duration      [total, attack, wait]      5m28.415278247s, 5m0.01040098s, 28.404877267s
Latencies     [mean, 50, 95, 99, max]    18.980141677s, 17.363145636s, 46.801815566s, 50.430838821s, 1m50.244745267s
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    71.29%
Status Codes  [code:count]               0:344425  200:855078
Error Set:
Get http://10.114.167.194:7080/sam: EOF
Get http://10.114.167.194:7080/sam: read tcp 10.114.153.15:32970->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.153.15:11037->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: read tcp 10.114.153.15:6576->10.114.167.194:7080: read: connection reset by peer
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.153.15:2131->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.167.194:7080/sam: readLoopPeekFailLocked: read tcp 10.114.153.15:21377->10.114.167.194:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
```

### 4000 RPS 300 seconds 100 ms latency 4096 workers and pool count 8 and Belfrage using c5n.2xlarge

This is the same as the previous load test with the load test client using a c5n.9xlarge. For this Belfrage was using a c5n.2xlarge.

The free CPU in Belfrage went down to 3%.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 4000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1199947, 3999.70, 2550.96
Duration      [total, attack, wait]      5m26.218187799s, 5m0.008898932s, 26.209288867s
Latencies     [mean, 50, 95, 99, max]    21.974898894s, 20.420761795s, 52.608360175s, 57.440874141s, 2m4.820429079s
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    69.35%
Status Codes  [code:count]               0:367779  200:832168
Error Set:
Get http://10.114.171.213:7080/sam: read tcp 10.114.153.15:58787->10.114.171.213:7080: read: connection reset by peer
Get http://10.114.171.213:7080/sam: read tcp 10.114.153.15:21002->10.114.171.213:7080: read: connection reset by peer
Get http://10.114.171.213:7080/sam: read tcp 10.114.153.15:52655->10.114.171.213:7080: read: connection reset by peer
Get http://10.114.171.213:7080/sam: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
Get http://10.114.171.213:7080/sam: readLoopPeekFailLocked: read tcp 10.114.153.15:63852->10.114.171.213:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.171.213:7080/sam: readLoopPeekFailLocked: read tcp 10.114.153.15:4605->10.114.171.213:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
Get http://10.114.171.213:7080/sam: readLoopPeekFailLocked: read tcp 10.114.153.15:23798->10.114.171.213:7080: read: connection reset by peer (Client.Timeout exceeded while awaiting headers)
```

### 4000 RPS 300 seconds 100 ms latency 4096 workers and pool count 16 and Belfrage using c5n.4xlarge

This is the same as the previous load test with the load test client using a c5n.9xlarge. For this Belfrage was using a c5n.4xlarge and had the pool count set to 16.

The free CPU in Belfrage went down to 6%. Belfrage was using 14000% CPU. The memory stayed on 3% with no increase. The graphs show much higher requests from Belfrage the issue was Belfrage not able to receive the requests previously.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 4000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1200000, 4000.00, 3998.57
Duration      [total, attack, wait]      5m0.106937793s, 4m59.999742423s, 107.19537ms
Latencies     [mean, 50, 95, 99, max]    108.08065ms, 107.989548ms, 109.870458ms, 111.029954ms, 311.194217ms
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:1200000
Error Set:
```

### 5000 RPS 300 seconds 100 ms latency 5120 workers and pool count 16

This is the same as the previous load test with Belfrage using a c5n.4xlarge and the pool count of 16. For this the workers are set to 5120.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 5000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1500000, 5000.00, 4998.19
Duration      [total, attack, wait]      5m0.10865415s, 4m59.999854564s, 108.799586ms
Latencies     [mean, 50, 95, 99, max]    122.445396ms, 112.565663ms, 168.792265ms, 272.094303ms, 676.918564ms
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:1500000
Error Set:
```

### 6000 RPS 300 seconds 100 ms latency 6144 workers and pool count 16

This is the same as the previous load test with Belfrage using a c5n.4xlarge and the pool count of 16. For this the workers are set to 6144.

Belfrage free CPU went to 26% but Belfrage struggled with the load. High system count of processes and ports and TCP connections compared to previous 5k load test. Load test client had read timeouts again.

```
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 300s -rate 6000 -header "origin-simulator:true" -max-body 0 -http2 false -insecure | vegeta report
Requests      [total, rate, throughput]  1799992, 5998.21, 1555.31
Duration      [total, attack, wait]      5m35.996559681s, 5m0.088168885s, 35.908390796s
Latencies     [mean, 50, 95, 99, max]    48.978256561s, 48.188088277s, 1m50.995075834s, 2m1.635738028s, 3m56.948351306s
Bytes In      [total, mean]              0, 0.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    29.03%
Status Codes  [code:count]               0:1277412  200:522580
Error Set:
Get http://10.114.152.191:7080/sam: dial tcp 0.0.0.0:0->10.114.152.191:7080: bind: address already in use
Get http://10.114.152.191:7080/sam: EOF
Get http://10.114.152.191:7080/sam: http: server closed idle connection
Get http://10.114.152.191:7080/sam: net/http: request canceled (Client.Timeout exceeded while awaiting headers)
Get http://10.114.152.191:7080/sam: read tcp 10.114.153.15:10689->10.114.152.191:7080: read: connection reset by peer
Get http://10.114.152.191:7080/sam: read tcp 10.114.153.15:56501->10.114.152.191:7080: read: connection reset by peer
Get http://10.114.152.191:7080/sam: read tcp 10.114.153.15:27162->10.114.152.191:7080: read: connection reset by peer
Get http://10.114.152.191:7080/sam: read tcp 10.114.153.15:27132->10.114.152.191:7080: read: connection reset by peer
Get http://10.114.152.191:7080/sam: read tcp 10.114.153.15:7469->10.114.152.191:7080: read: connection reset by peer
Get http://10.114.152.191:7080/sam: read tcp 10.114.153.15:49133->10.114.152.191:7080: read: connection reset by peer
Get http://10.114.152.191:7080/sam: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
Get http://10.114.152.191:7080/sam: http: server closed idle connection (Client.Timeout exceeded while awaiting headers)
```

## Discussion of Results
To reiterate, we want to discover from these load tests:
- If there are any issues with Finch or NimblePool.
- How much load Belfrage is able to handle without pool issues.
- The performance of Belfrage using Finch compared to using Machine Gun.

### Finch issues

When load testing there were no issues found with Finch. There are some code improvements we would need to make such as how we specify pools. Currently it needs an endpoint whereas we would map to a name.

Nimble Pool had timeouts during some of the load tests. This was before setting the pool count. When setting this to the same number of cores these went away and we ended up with application errors we had not seen before.

### Belfrage load

On the current instance type of c5.2xlarge we can easily get to 2000 rps with one second latency. When the latency is 100ms for 3000 rps the responses are slow around 400ms for Belfrage processing only. A c5n.2xlarge reduces this to around 200ms for Belfrage processing only.

To achieve over 3000 rps we need to use a c5n.4xlarge. Note the c5.4xlarge was not compared. For 4000 rps this produced 8ms response time. For 5000 rps this produced 22ms response time. 6000 rps was not achievable. This would require more work to identify the CPU usage.

The number of pools ended up being set to the number of cores to remove any Nimble Pool timeout errors. This ended up with application errors which need looking into.

### Finch compared to Machine Gun

In previous load tests using Machine Gun looking at the 1000 - 1200 requests per second with one second latency these produced 500 status errors.

The Finch tests show we can easily achieve 2000 rps with one second latency from the origin. The pool size was 2048 for this.

This was then expanded using tests with 100ms latency from the origin. To get over 2000 rps we needed to sidestep parts of the Belfrage application. This has indicated areas for improvement. The number of pools was increased to the number of cores.

When under high load Finch is a little slower and has less spiky response times compared to Machine Gun which has high response times and can produce errors.

## Conclusion

From the load tests it is clear Finch is more performant than Machine Gun and we can achieve a higher request rate using this. To use this in production this will require more work. Independently of this we should look to fix the areas of the Belfrage codebase these load tests identified.
