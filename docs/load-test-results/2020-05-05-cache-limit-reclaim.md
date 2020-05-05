# Test Results: cache limit and reclaim

## Context

To prevent local (tier-1) cache from consuming all available VM memory and causing crashes at higher request rates, a cache limit and reclaim mechanism is configured. The mechanism is based on [Cachex size limit](https://hexdocs.pm/cachex/cache-limits.html) and its default least-recently-written (LRW) reclaim policy.

## Hypotheses

- cache limit and reclaim mechanism stabilises memory usage at higher request rates (425rps)
- cache limit and reclaim mechanism is performant at higher request rates (425rps)

## Setup
- Vegeta Runner on EC2, Repeater, Requests to Belfrage playground

## Tests

Run the following tests (0ms simulated latency) on Belfrage playground with OriginSimulator returning gzip payload (e.g. [single-route recipe](data/2020-05-05/recipe.json)):

#### Vegata
- 1200s/20min 425rps 1kb payload: on a single-route with `cache-bust`, so that all requests are cached
- 240s 425rps 100kb payload: on a single-route with `cache-bust`, so that all requests are cached
- 130s 425rps 300kb payload: on a single-route with `cache-bust`, so that all requests are cached

#### Repeater
- 1-hour 50% Repeater traffics (~500rps), OriginSimulator returning 100kb gzip payload

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



Starting load test: 1200secs_425rps
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 1200s -rate 425 -http2 false -insecure | tee /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.bin | vegeta report

Requests      [total, rate, throughput]  510000, 425.00, 425.00
Duration      [total, attack, wait]      19m59.999891563s, 19m59.997583735s, 2.307828ms
Latencies     [mean, 50, 95, 99, max]    2.521708ms, 2.33836ms, 3.331595ms, 5.818934ms, 188.062311ms
Bytes In      [total, mean]              522240000, 1024.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:510000  
Error Set:

Generating metrics: vegeta report -type=json --output /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.json /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.bin
Generating plot: vegeta plot /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.bin > /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report-plot.html
"Generating histogram: vegeta report -type=\"hist[0,20ms,40ms,60ms,80ms,100ms,200ms,300ms,400ms,500ms]\" --output /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report-hist.txt /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.bin"
"Generating hdr plot: vegeta report -type=hdrplot --output /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report-hdrplot.txt /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.bin"
"Cleanup: rm /opt/belfrage-wrk2-loadtest/results/vegeta-1200s-425rps/1200secs_425rps/report.bin"
Connection to 10.114.164.81,eu-west-1 closed.
Downloading results
report.json                                                                                                                                                               100%  484    14.9KB/s   00:00    
report-plot.html                                                                                                                                                          100%  390KB   1.7MB/s   00:00    
report-hist.txt                                                                                                                                                           100%  457    15.9KB/s   00:00    
report-hdrplot.txt                                                                                                                                                        100% 4503   121.1KB/s   00:00    
Result links created
Results downloaded. Upload key: vegeta-1200s-425rps-1588631134357




----------------


Starting load test: 130secs_425rps
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 130s -rate 425 -http2 false -insecure | tee /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin | vegeta report

tee: /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin: No space left on device
Requests      [total, rate, throughput]  55250, 425.00, 424.96
Duration      [total, attack, wait]      2m10.010713183s, 2m9.999099338s, 11.613845ms
Latencies     [mean, 50, 95, 99, max]    15.452684ms, 12.77082ms, 22.946067ms, 80.542584ms, 260.710218ms
Bytes In      [total, mean]              16972800000, 307200.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:55250  
Error Set:

Generating metrics: vegeta report -type=json --output /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.json /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin
Generating plot: vegeta plot /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin > /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report-plot.html
"Generating histogram: vegeta report -type=\"hist[0,20ms,40ms,60ms,80ms,100ms,200ms,300ms,400ms,500ms]\" --output /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report-hist.txt /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin"
"Generating hdr plot: vegeta report -type=hdrplot --output /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report-hdrplot.txt /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin"
"Cleanup: rm /opt/belfrage-wrk2-loadtest/results/vegeta-130s-425rps/130secs_425rps/report.bin"
Connection to 10.114.168.16,eu-west-1 closed.
Downloading results
Result links created
Results downloaded. Upload key: vegeta-130s-425rps-1588632898686

------------

Starting load test: 240secs_425rps
vegeta attack -targets /opt/belfrage-wrk2-loadtest/targets.txt -duration 240s -rate 425 -http2 false -insecure | tee /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin | vegeta report

tee: /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin: No space left on device
Requests      [total, rate, throughput]  102000, 425.00, 425.00
Duration      [total, attack, wait]      4m0.002820888s, 3m59.99769443s, 5.126458ms
Latencies     [mean, 50, 95, 99, max]    20.034503ms, 5.107651ms, 47.022381ms, 492.909593ms, 1.615765821s
Bytes In      [total, mean]              10444800000, 102400.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:102000  
Error Set:

Generating metrics: vegeta report -type=json --output /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.json /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin
Generating plot: vegeta plot /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin > /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report-plot.html
"Generating histogram: vegeta report -type=\"hist[0,20ms,40ms,60ms,80ms,100ms,200ms,300ms,400ms,500ms]\" --output /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report-hist.txt /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin"
"Generating hdr plot: vegeta report -type=hdrplot --output /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report-hdrplot.txt /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin"
"Cleanup: rm /opt/belfrage-wrk2-loadtest/results/vegeta-240s-425rps/240secs_425rps/report.bin"
Connection to 10.114.168.16,eu-west-1 closed.
Downloading results
Result links created
Results downloaded. Upload key: vegeta-240s-425rps-1588684181733
Load test run complete
✨  Done in 261.40s.



---------

iex(belfrage@10.114.166.240)1> :msacc.start 60000
true
iex(belfrage@10.114.166.240)2> :msacc.print
Average thread real-time    :  60004247 us
Accumulated system run-time : 336528188 us
Average scheduler run-time  :  41868902 us

        Thread    alloc      aux      bifbusy_wait check_io emulator      ets       gc  gc_full      nif    other     port     send    sleep   timers

Stats per thread:
     async( 0)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
     async( 1)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
     async( 2)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
     async( 3)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
     async( 4)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
       aux( 1)    0.00%    0.01%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%   99.98%    0.00%
dirty_cpu_( 1)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_cpu_( 2)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_cpu_( 3)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_cpu_( 4)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_cpu_( 5)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_cpu_( 6)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_cpu_( 7)    0.00%    0.00%    0.00%    0.07%    0.00%    0.00%    0.00%    0.01%    0.01%    0.00%    0.00%    0.00%    0.00%   99.91%    0.00%
dirty_cpu_( 8)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 1)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 2)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 3)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 4)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 5)    0.00%    0.00%    0.00%    0.83%    0.00%    0.00%    0.00%    0.00%    0.00%    0.01%    0.00%    0.00%    0.00%   99.15%    0.00%
dirty_io_s( 6)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 7)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 8)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s( 9)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
dirty_io_s(10)    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
      poll( 0)    0.08%    0.00%    0.00%    0.00%    1.60%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%   98.32%    0.00%
 scheduler( 1)    4.04%    0.35%    3.80%    4.06%    0.81%   11.96%    2.23%    3.71%    0.46%   34.61%    0.72%    1.93%    0.93%   30.38%    0.03%
 scheduler( 2)    4.23%    0.39%    3.81%    4.12%    0.85%   12.10%    2.32%    3.73%    0.46%   34.15%    0.73%    2.00%    0.99%   30.10%    0.03%
 scheduler( 3)    4.16%    0.35%    3.78%    4.36%    0.80%   12.02%    2.27%    3.74%    0.47%   34.23%    0.73%    1.94%    0.96%   30.14%    0.03%
 scheduler( 4)    4.28%    0.38%    3.79%    3.99%    0.80%   11.91%    2.24%    3.67%    0.45%   34.51%    0.66%    1.99%    0.91%   30.37%    0.03%
 scheduler( 5)    4.13%    0.35%    3.79%    4.10%    0.85%   12.01%    2.27%    3.78%    0.47%   34.10%    0.82%    1.98%    0.92%   30.41%    0.03%
 scheduler( 6)    4.28%    0.39%    3.71%    4.11%    0.77%   11.78%    2.22%    3.69%    0.47%   34.99%    0.69%    1.92%    0.90%   30.05%    0.03%
 scheduler( 7)    4.25%    0.38%    3.79%    4.25%    0.78%   11.64%    2.26%    3.62%    0.45%   34.88%    0.71%    1.90%    0.97%   30.08%    0.03%
 scheduler( 8)    4.21%    0.36%    3.77%    3.99%    0.78%   11.99%    2.36%    3.76%    0.48%   34.36%    0.80%    1.94%    0.92%   30.24%    0.03%

Stats per type:
         async    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%  100.00%    0.00%
           aux    0.00%    0.01%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%   99.98%    0.00%
dirty_cpu_sche    0.00%    0.00%    0.00%    0.01%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%   99.99%    0.00%
dirty_io_sched    0.00%    0.00%    0.00%    0.08%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%   99.92%    0.00%
          poll    0.08%    0.00%    0.00%    0.00%    1.60%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%    0.00%   98.32%    0.00%
     scheduler    4.20%    0.37%    3.78%    4.12%    0.81%   11.92%    2.27%    3.71%    0.46%   34.48%    0.73%    1.95%    0.94%   30.22%    0.03%