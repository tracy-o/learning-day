# Load Test Results - Small Message Casting

## Context
We are considering a layer that receives many, small cast messages from Belfrage, with runtime introspective data. This is part of the "Runtime Introspective" Belfrage epic.

## Hypothesis

- The performance implication of sending varying numbers of 2_000 byte messages (GenServer cast) from Belfrage to Monitor app is negligible. This is comparing the `RESFRAME-3629` branch, to `master`.

NOTE: 2_000 was picked because an empty %Belfrage.Struct{} is 1_300 bytes in length when stringified.

## Setup
- Vegeta Runner on EC2
- Requests to Belfrage playground: cache-bust on
- OriginSimulator on EC2: Type: 1 x c5.2xlarge instance, CPUs: 8 vCPUs (4 core, 2 threads per core)
- Monitor on EC2: Type: 1x t3.micro instance, CPUs: 2, memory: 1GiB
- OriginSimulator simulate 300kb payload (random_content recipe)
```
{
    "random_content": "300kb",
    "stages": [
        { "at": 0, "status": 200, "latency": "0ms"}
    ],
    "headers": {
      "content-encoding": "gzip"
    }
}
```

## Tests
Run the following tests with and without messaging () between Belfrage and CPP

1. 60s, 200rps - 0 messages per request
2. 60s, 200rps - 10 messages per request
3. 60s, 200rps - 20 messages per request
4. 60s, 200rps - 40 messages per request

## Results

#### 60s, 200rps - 0 messages per request

```
ID: vegeta-60s-200rps-1595504178552
Requests      [total, rate, throughput]  11997, 199.93, 199.82
Duration      [total, attack, wait]      1m0.03829011s, 1m0.006713159s, 31.576951ms
Latencies     [mean, 50, 95, 99, max]    34.856965ms, 30.985871ms, 68.66235ms, 92.616884ms, 155.06028ms
Bytes In      [total, mean]              3685478400, 307200.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:11997
Error Set:
```

[Results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-60s-200rps-1595504178552)

#### 60s, 200rps - 10 messages per request

```
ID: vegeta-60s-200rps-1595493499081
Requests      [total, rate, throughput]  12000, 200.00, 199.85
Duration      [total, attack, wait]      1m0.046470599s, 59.998774182s, 47.696417ms
Latencies     [mean, 50, 95, 99, max]    30.857067ms, 27.331684ms, 60.002537ms, 82.666984ms, 144.752896ms
Bytes In      [total, mean]              3686400000, 307200.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:12000
Error Set:
```

[Results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-60s-200rps-1595493792600)

#### 60s, 200rps - 20 messages per request

```
ID: vegeta-60s-200rps-1595503020797
Requests      [total, rate, throughput]  11999, 199.99, 199.86
Duration      [total, attack, wait]      1m0.036118761s, 59.998453807s, 37.664954ms
Latencies     [mean, 50, 95, 99, max]    34.548585ms, 30.299855ms, 68.854684ms, 96.869586ms, 167.687276ms
Bytes In      [total, mean]              3686092800, 307200.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:11999
Error Set:
```

[Results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-60s-200rps-1595503020797)

#### 60s, 200rps - 40 messages per request

```
ID: vegeta-60s-200rps-1595503308237
Requests      [total, rate, throughput]  12000, 199.93, 199.90
Duration      [total, attack, wait]      1m0.030025385s, 1m0.020475858s, 9.549527ms
Latencies     [mean, 50, 95, 99, max]    38.266587ms, 32.575085ms, 79.608651ms, 131.151844ms, 294.451426ms
Bytes In      [total, mean]              3686400000, 307200.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:12000
Error Set:
```

[Results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-60s-200rps-1595503308237)

## Comparison

HDR plots

## Notes:

- For all tests, a maximum of 30% CPU was used.
- For all tests, memory used was always below 9%.
