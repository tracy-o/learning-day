# Finch VS Machine Gun
- Machine Gun is a project which combines poolboy pools with the gun HTTP client.
- Finch is a project which combines nimblepool with the mint HTTP client.

We want to move to Finch because:
- In previous load tests (see [testing-finch-http-client](./2021-09-20-testing-finch-http-client.md)) we've found that finch is more performant that machine gun.
- Machine Gun is a sticking point in us upgrading to OTP 24 meaning we can't use the ASM JIT on Belfrage yet.
- Finch is promising as it's performance focused and uses nimble_pool created by Jose Valim.

The goal of these load tests is to determine **is it safe to roll out Finch as our HTTP client in production?**

## Load Tests using Machine Gun
- Stack: www test Belfrage stack
- Branch:  `master` `87cf5036389c666fe7944fc843decad94448ec73`
- Instance Type: c5.2xlarge
- Scaling: Limited to 1 instance

The origin was configured with 1 second latency to return the `/news` page for the BBC website.
```
[
    {
        "stages": [
            {
                "status": 200,
                "latency": "1s",
                "at": 0
            }
        ],
        "route": "/*",
        "random_content": null,
        "origin": "https://www.bbc.co.uk/news",
        "headers": {
            "content-type": "text/html; charset=utf-8",
            "content-encoding": "gzip"
        },
        "body": null
    }
]
```

###  700 RPS 600 Seconds
Vegeta Report
```
$ date && echo "GET https://www.belfrage.test.api.bbc.co.uk/news" | vegeta attack -duration=600s -rate=700 -header "replayed-traffic:true" -http2 false -max-body=0 -timeout=30s | tee machinegun_1s_l_600s_d_700rps_30s_timeout_results.bin | vegeta report
Tue  5 Jul 10:52:35 UTC 2022
Requests      [total, rate, throughput]  420001, 700.00, 382.77
Duration      [total, attack, wait]      10m1.008528329s, 9m59.999875195s, 1.008653134s
Latencies     [mean, 50, 95, 99, max]    796.71742ms, 1.006793049s, 1.033523183s, 1.069909201s, 1.600541773s
Bytes In      [total, mean]              99323627400, 236484.26
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    54.77%
Status Codes  [code:count]               0:189951  200:230050
Error Set:
Get https://www.belfrage.test.api.bbc.co.uk/news: http2: server sent GOAWAY and closed the connection; LastStreamID=3101, ErrCode=ENHANCE_YOUR_CALM, debug=""
Get https://www.belfrage.test.api.bbc.co.uk/news: http2: server sent GOAWAY and closed the connection; LastStreamID=3103, ErrCode=ENHANCE_YOUR_CALM, debug=""
Get https://www.belfrage.test.api.bbc.co.uk/news: http2: server sent GOAWAY and
...
```


Responses
![](./img/2022-07-05-finch-vs-machinegun/machinegun_600s_700rps_reponses.png)

CPU
![](./img/2022-07-05-finch-vs-machinegun/machinegun_600s_700rps_cpu.png)

Pool workers
![](./img/2022-07-05-finch-vs-machinegun/machinegun_600s_700rps_workers.png)

Origin Simulator Response Timings
![](./img/2022-07-05-finch-vs-machinegun/machinegun_originsimulator_timings.png)

VM Queue
![](./img/2022-07-05-finch-vs-machinegun/machinegun_queue_length.png)

### 700 RPS 120 Seconds
The binary of long load tests are too large to produce a graph. So I ran a shorter load test in order to visualise latency and client status over time.

![](./img/2022-07-05-finch-vs-machinegun/machinegun_1s_l_120s_d_700rps_30s_timeout_results_plot.png)


## Load Tests using Finch 
- Stack: www test Belfrage stack
- Branch:  `RESFRAME-4763-finch-programmes` `042a63eaedf3dbf2cd47fa0b61c6a4a29f079dff`
- Instance Type: c5.2xlarge
- Scaling: Limited to 1 instance

Finch was configured to use 512 workers for the `OriginSimulator` endpoint.

The origin was configured with 1 second latency to return the `/news` page for the BBC website.
```
[
    {
        "stages": [
            {
                "status": 200,
                "latency": "1s",
                "at": 0
            }
        ],
        "route": "/*",
        "random_content": null,
        "origin": "https://www.bbc.co.uk/news",
        "headers": {
            "content-type": "text/html; charset=utf-8",
            "content-encoding": "gzip"
        },
        "body": null
    }
]
```

###  700 RPS 600 Seconds
Vegeta Report
```
$ date && echo "GET https://www.belfrage.test.api.bbc.co.uk/news" | vegeta attack -duration=600s -rate=700 -header "replayed-traffic:true" -http2 false -max-body=0 -timeout=30s | tee finch_1s_l_600s_d_700rps_30s_timeout_results.bin | vegeta report
Tue  5 Jul 12:39:41 UTC 2022
Requests      [total, rate, throughput]  420001, 700.00, 334.33
Duration      [total, attack, wait]      10m1.631088297s, 9m59.999878872s, 1.631209425s
Latencies     [mean, 50, 95, 99, max]    900.2049ms, 1.007846299s, 1.306505741s, 1.346030511s, 2.163808065s
Bytes In      [total, mean]              86843951460, 206770.82
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    47.89%
Status Codes  [code:count]               0:218856  200:201145
Error Set:
Get https://www.belfrage.test.api.bbc.co.uk/news: http2: server sent GOAWAY and closed the connection; LastStreamID=3443, ErrCode=ENHANCE_YOUR_CALM, debug=""
Get https://www.belfrage.test.api.bbc.co.uk/news: http2: server sent GOAWAY and closed the connection; LastStreamID=3471, ErrCode=ENHANCE_YOUR_CALM, debug=""
Get https://www.belfrage.test.api.bbc.co.uk/news: http2: server sent GOAWAY and closed the connection; LastStreamID=3467, ErrCode=ENHANCE_YOUR_CALM, debug=""
...
```

Responses
![](./img/2022-07-05-finch-vs-machinegun/finch_600s_700rps_responses.png)

CPU
![](./img/2022-07-05-finch-vs-machinegun/finch_600s_700rps_cpu.png)

Pool Workers
![](./img/2022-07-05-finch-vs-machinegun/nimblepool_graph.png)

Origin Simulator Response Timings
![](./img/2022-07-05-finch-vs-machinegun/finch_originsimulator_timings.png)

VM Queue
![](./img/2022-07-05-finch-vs-machinegun/finch_queue_length.png)

### 700 RPS 120 Seconds
The binary of long load tests are too large to produce a graph. So I ran a shorter load test in order to visualise latency and client status over time.

![](./img/2022-07-05-finch-vs-machinegun/finch_1s_l_120s_d_700rps_30s_timeout_results_plot.png)


### Comparative Graphs
Here if possible we put the load tests side by side to make it easier to visually compare them. The first peak is the Machine Gun load test, the second peak is the finch load test.

Responses
![](./img/2022-07-05-finch-vs-machinegun/comparison_responses.png)

CPU
![](./img/2022-07-05-finch-vs-machinegun/comparison_cpu.png)

Origin Simulator Timings
![](./img/2022-07-05-finch-vs-machinegun/comparison_origin_simulator%20_timings.png)

VM Queue
![](./img/2022-07-05-finch-vs-machinegun/comparison_origin_simulator_queue_length.png)


## Discussion
We can see that in a high latency environment Finch and Machine Gun perform similarly.

Finches max latency is significantly higher than Machine Gun's (1.75s vs 2s approx) However its 99 percentile latency is only about 0.3s difference (1.34s vs 1.06) so this poor performance is only in extreme cases.
Finch also has a slightly lower success ratio (48% vs 55%) and has a longer VM queue while under load.

We can also see the VM Run Queue length is higher (1 vs 10). However I don't think this an issue as it just means that 10 tasks are waiting to be processed by the BEAM VM process scheduler. If the queue increase until the end of the load test then we would know that there were too many tasks to schedule, but the recovery of the queue length indicates it was transient.

Some of this could be explained by Finch's 512 worker configuration as opposed to Machine Guns 512 workers with 4096 overflow workers. We can see that all of Machine Guns workers and about 200 overflow workers are in use. Meaning its not quite an equal comparison. Also there are other levers we could pull to increase performance in Finch such as increasing the `count` per pool. (see [here](https://github.com/bbc/belfrage/pull/1484))

We also see that the CPU usage with Finch is much lower than Machine Gun's (37% vs 56%). There are two factors which could contribute to this. One is the Machine Gun overflow workers which we already know are inefficient, the other is Finch's superior performance.

## Conclusion
The goal of these load tests was to answer: **Is Finch safe for production?** I think **the answer to this is yes**. Even with low latency origins it performs similarly to Machine Gun, while using less CPU. If we are happy having Machine Gun in production we should be happy using Finch. 



