# Test results: Comparing the new c6gn.2xlarge EC2 to the c5.2xlarge EC2

## Context

Amazon Web Services have recently released their new C6 generation of EC2 which are powered by Arm-based AWS Graviton2 processors, "They deliver up to 40% better price performance over current generation C5 instances".

The specific instances we will be testing are the c6gn instances which have 100 Gbps networking and Elastic Fabric Adapter and are to be used for applications that need higher networking throughput.
[c6gn instance type](https://aws.amazon.com/ec2/instance-types/c6/)

## Hypotheses

- The new c6gn.2xlarge EC2 has reduced latency and maintains correctness when compared to c5.2xlarge EC2

## Setup

- To verify the performance of the c6gn instance we will use vegeta and Origin Simulator. Vegeta will allow us to send a consistant and accurate stream of requests to Belfrage which will then send requests upstream to Origin Simulator.
- We will be varying the rate between 400 and 1200 requests per second using Vegeta 

### Origin Simulator Recipe

	{
	  "stages":[{"status":200,"latency":"100ms","at":0}],
	  "route":"/*",
	  "random_content":"200kb",
	  "origin":null,
	  "headers":{"content-type":"text/html; charset=utf-8","content-encoding":"gzip"},
	  "body":null
	}

### Vegeta config

	echo "GET endpoint" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=400 -workers=20 | tee results.bin | vegeta report

## Tests

We conducted tests at 400, 800, 1000, 1100 and 1200 requests per second

### Test 1 - 400 requests per second

##### c6gn EC2
	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=400 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  24000, 400.02, 399.31
	Duration      [total, attack, wait]      1m0.103771332s, 59.997441443s, 106.329889ms
	Latencies     [mean, 50, 95, 99, max]    107.381249ms, 107.344525ms, 108.037064ms, 108.738144ms, 156.705088ms
	Bytes In      [total, mean]              4915200000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:24000  
	Error Set:

  ##### c5 EC2
  
	echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=400 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  24000, 400.01, 399.30
	Duration      [total, attack, wait]      1m0.105059575s, 59.997910334s, 107.149241ms
	Latencies     [mean, 50, 95, 99, max]    107.30513ms, 107.242312ms, 108.059444ms, 108.725476ms, 145.193336ms
	Bytes In      [total, mean]              4915200000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:24000  
	Error Set:
##### Test 1 summary

As you can see the latency results are very similar for both EC2s which is what we would expect with request rate on the lower end.

### Test 2 - 800 requests per second

##### c6gn EC2
	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=800 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  48000, 800.02, 798.58
	Duration      [total, attack, wait]      1m0.106652688s, 59.998833289s, 107.819399ms
	Latencies     [mean, 50, 95, 99, max]    109.012389ms, 108.36651ms, 110.854535ms, 122.173279ms, 370.682838ms
	Bytes In      [total, mean]              9830400000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:48000  
	Error Set:

  ##### c5 EC2
  
	echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=800 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  48000, 800.02, 798.55
	Duration      [total, attack, wait]      1m0.108761161s, 59.998762086s, 109.999075ms
	Latencies     [mean, 50, 95, 99, max]    111.416882ms, 108.667686ms, 111.542365ms, 202.786576ms, 563.359445ms
	Bytes In      [total, mean]              9830400000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:48000  
	Error Set:

##### Test 2 summary

Again the results are extremely similar however you can begin to see the c6gn EC2 performing slightly better at the upper percentiles and mean latencies.

### Test 3 - 1200 requests per second

##### c6gn EC2
	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1200 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  71993, 1199.71, 1197.47
	Duration      [total, attack, wait]      1m0.121148399s, 1m0.008650176s, 112.498223ms
	Latencies     [mean, 50, 95, 99, max]    348.938862ms, 160.933061ms, 997.138902ms, 1.311606419s, 3.194031457s
	Bytes In      [total, mean]              14744166400, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:71993  
	Error Set:

  ##### c5 EC2
  
	echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1200 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  72000, 1200.02, 22.76
	Duration      [total, attack, wait]      1m0.023772302s, 59.999213439s, 24.558863ms
	Latencies     [mean, 50, 95, 99, max]    27.865508ms, 5.192828ms, 21.283559ms, 447.355864ms, 6.4345737s
	Bytes In      [total, mean]              279756800, 3885.51
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    1.90%
	Status Codes  [code:count]               200:1366  500:70634  
	Error Set:
	500 Internal Server Error

##### Test 3 summary

Looking at the latency results you may believe the c5 drastically out performed the c6gn however this is not the case, as you can see over 70,000 of the 72,000 requests sent were 500s meaning the c5 was unable to handle the load at all while the c6gn was.

### Test 4 - 1100 requests per second

##### c6gn EC2
	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1100 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  66000, 1100.02, 1098.06
	Duration      [total, attack, wait]      1m0.106220745s, 59.999002605s, 107.21814ms
	Latencies     [mean, 50, 95, 99, max]    210.272567ms, 136.843119ms, 506.639756ms, 730.204182ms, 1.05196217s
	Bytes In      [total, mean]              13516800000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:66000  
	Error Set:

  ##### c5 EC2
  
	echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1100 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  65993, 1099.87, 1097.89
	Duration      [total, attack, wait]      1m0.108798284s, 1m0.000636009s, 108.162275ms
	Latencies     [mean, 50, 95, 99, max]    168.122191ms, 116.035817ms, 357.80252ms, 483.565921ms, 774.309183ms
	Bytes In      [total, mean]              13515366400, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:65993  
	Error Set:

##### Test 4 summary

This test is quite counterintuitive to what we have been seeing so far, the c5 has outperformed the c6gn in all latency values.

### Test 5 - 1000 requests per second
##### c6gn EC2

	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1000 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  60000, 1000.01, 998.23
	Duration      [total, attack, wait]      1m0.106372008s, 59.999111096s, 107.260912ms
	Latencies     [mean, 50, 95, 99, max]    143.856714ms, 113.276955ms, 286.943933ms, 422.429104ms, 697.551332ms
	Bytes In      [total, mean]              12288000000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:60000  
	Error Set: 

  ##### c5 EC2
  
	echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1000 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  60000, 1000.02, 998.19
	Duration      [total, attack, wait]      1m0.109018107s, 59.998989623s, 110.028484ms
	Latencies     [mean, 50, 95, 99, max]    140.907604ms, 115.081379ms, 247.647949ms, 319.522556ms, 494.719319ms
	Bytes In      [total, mean]              12288000000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:60000  
	Error Set:
##### Test 5 summary

This test is again following the trend for test 4, the c5 is outperforming the c6gn in almost every lantency value.

## Results

 Looking at the results it would seem that the new c6gn EC2 does not simply beat the current generation c5 EC2. The c6gn performes the same if not slightly better on the lower end of the requests count and has a higher maxium load as it did not crash when the request count hit 1200 per second. However, on the upper end of that range e.g. 1000 and 1100 requests per second the c5 is able to out perform the c6gn in almost ever latency value.