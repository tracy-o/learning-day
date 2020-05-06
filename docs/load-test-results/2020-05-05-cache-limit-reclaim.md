# Test Results: cache limit and reclaim

## Context

To prevent local (tier-1) cache from consuming all available VM memory and causing crashes at higher request rates, a cache limit and reclaim mechanism is configured. The mechanism is based on [Cachex size limit](https://hexdocs.pm/cachex/cache-limits.html) and its default least-recently-written (LRW) reclaim policy.

## Hypotheses

- cache limit and reclaim mechanism stabilises memory usage at higher request rates (425rps)
- cache limit and reclaim mechanism is performant at higher request rates (425rps)

## Setup
- Vegeta Runner on EC2, Repeater, Requests to Belfrage playground
- Cache: 36k max size, LRW reclaim policy, reclaim ratio: 0.3 (30%)

## Tests

Run the following tests (0ms simulated latency) on Belfrage playground with OriginSimulator returning gzip payload (e.g. [single-route recipe](data/2020-05-05/recipe.json)):

#### Vegata

- 1200s/20min 425rps 1kb payload: on a single-route with `cache-bust`, so that all requests are cached
- 240s 425rps 100kb payload: on a single-route with `cache-bust`, so that all requests are cached
- 130s 425rps 300kb payload: on a single-route with `cache-bust`, so that all requests are cached

#### Repeater

- 30-minute 50% Repeater traffics (~500rps), OriginSimulator returning 100kb gzip payload

During the tests, the following BEAM VM stats was sampled at 1s frequency (30s for Repeater test) by running [this script]() in IEx remote console:

- memory usage
- CPU usage
- cache table (ETS) size
- cache table memory usage

For the Repeater test, a one-minute [microstate accounting](https://erlang.org/doc/man/msacc.html) was also run to measure the time spent on various system tasks. To enable reporting with additional states accounting (e.g. `busy wait`, `NIF` states), Erlang run-time was compiled with `--with-microstate-accounting=extra` configuration. On the Playground EC2 instance where `asdf` was installed, the configuration was enabled with the `KERL_CONFIGURE_OPTIONS` environment variable prior to installation: 

```
$ export KERL_CONFIGURE_OPTIONS="--with-microstate-accounting=extra"
$ asdf install erlang  22.3.3
```

## Results

Analysis to follow

#### Vegeta

*1200s, 425rps, 1kb, cache-bust*

```
ID: 1588631134357
Requests      [total, rate, throughput]  510000, 425.00, 425.00
Duration      [total, attack, wait]      19m59.999891563s, 19m59.997583735s, 2.307828ms
Latencies     [mean, 50, 95, 99, max]    2.521708ms, 2.33836ms, 3.331595ms, 5.818934ms, 188.062311ms
Bytes In      [total, mean]              522240000, 1024.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:510000  
```

[Results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-1200s-425rps-1588631134357)

![plot](img/2020-05-05/1200s_425rps_1kb_mem.png)

![plot](img/2020-05-05/1200s_425rps_1kb_cpu.png)

![plot](img/2020-05-05/1200s_425rps_1kb_cache_size.png)

*240s, 425rps, 100kb, cache-bust*

```
ID: 1588684181733
Requests      [total, rate, throughput]  102000, 425.00, 425.00
Duration      [total, attack, wait]      4m0.002820888s, 3m59.99769443s, 5.126458ms
Latencies     [mean, 50, 95, 99, max]    20.034503ms, 5.107651ms, 47.022381ms, 492.909593ms, 1.615765821s
Bytes In      [total, mean]              10444800000, 102400.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:102000
```

No further Vegeta results due to incomplete reporting from load test instance (ran out of space when generating report).

![plot](img/2020-05-05/240s_425rps_100kb_mem.png)

![plot](img/2020-05-05/240s_425rps_100kb_cpu.png)

![plot](img/2020-05-05/240s_425rps_100kb_cache_size.png)

*130s, 425rps, 300kb, cache-bust*

```
Requests      [total, rate, throughput]  55250, 425.00, 424.96
Duration      [total, attack, wait]      2m10.010713183s, 2m9.999099338s, 11.613845ms
Latencies     [mean, 50, 95, 99, max]    15.452684ms, 12.77082ms, 22.946067ms, 80.542584ms, 260.710218ms
Bytes In      [total, mean]              16972800000, 307200.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:55250  
```

No further Vegeta results due to incomplete reporting from load test instance (ran out of space when generating report).

![plot](img/2020-05-05/130s_425rps_300kb_mem.png)

![plot](img/2020-05-05/130s_425rps_300kb_cpu.png)

![plot](img/2020-05-05/130s_425rps_300kb_cache_size.png)

#### Repeater: 30-minutes 50% traffics

*CloudWatch metrics*

- Number of requests: ~900k
- 200 status response time: 8.9ms - 18.9ms
- Cache hit ratio: 34%

![plot](img/2020-05-05/30min_50percent_repeater_100kb_stats.png)

*VM stats*

![plot](img/2020-05-05/30min_50percent_repeater_100kb_mem.png)

![plot](img/2020-05-05/30min_50percent_repeater_100kb_cpu.png)

![plot](img/2020-05-05/30min_50percent_repeater_100kb_cache_size.png)

*BEAM microstate accounting stats: 1-minute sample*

|     Thread     | alloc |  aux  |  bif  | busy_wait | check_io | emulator | ets | gc | gc_full | nif | other | port | send | sleep | timers |
|----------------|-------|-------|-------|-----------|----------|----------|-----|----|---------|-----|-------|------|------|-------|--------|
| dirty_cpu_sche | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 100.00% | 0.00% |
| dirty_io_sched | 0.00% | 0.00% | 0.00% | 0.07% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 99.92% | 0.00% |
| poll | 0.09% | 0.00% | 0.00% | 0.00% | 1.62% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 0.00% | 98.29% | 0.00% |
| scheduler | 4.83% | 0.46% | 4.32% | 5.55% | 0.96% | 13.79% | 2.53% | 4.24% | 0.61% | 51.74% | 0.87% | 2.18% | 1.04% | 6.83% | 0.03% |