# Test results: Comparing the new c6gn.2xlarge EC2 to the c5.2xlarge EC2

## Context

Amazon Web Services have recently released their new C6 generation of EC2 which are powered by Arm-based AWS Graviton2 processors, "They deliver up to 40% better price performance over current generation C5 instances".

The specific instances we will be testing are the c6gn instances which have 100 Gbps networking and Elastic Fabric Adapter and are to be used for applications that need higher networking throughput.
[c6gn instance type](https://aws.amazon.com/ec2/instance-types/c6/)

## Hypotheses

- The new c6gn.2xlarge EC2 has reduced latency and maintains a high proportion of success status codes when compared to c5.2xlarge EC2

## Setup

- To verify the performance of the c6gn instance we will use vegeta and Origin Simulator. Vegeta will allow us to send a consistent and accurate stream of requests to Belfrage which will then send requests upstream to Origin Simulator.
- We will be varying the rate between 400 and 1200 requests per second using Vegeta 
- We created a standalone c6gn EC2 instance on which we then installed belfrage
- For the c5 EC2 we used bruce-belfrage test
- All tests have been run once

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

	echo "GET endpoint" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=X -workers=20 | tee results.bin | vegeta report

## Tests

We conducted tests at 400, 800, 1000, 1100 and 1200 requests per second, for 60 seconds.

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

Again the results are similar for all latency values.

### Test 3 - 1000 requests per second
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
	
##### Test 3 summary

This test is again following the trend for test 2, both the c5 and c6gn are similar in almost every lantency value.

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

This test shows the c5 EC2 sligthly outperforming the c6gn in all latency values.

### Test 5 - 1200 requests per second

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

##### Test 5 summary

Looking at the latency results you may believe the c5 drastically out performed the c6gn however this is not the case, as you can see over 70,000 of the 72,000 requests sent were 500s meaning the c5 was unable to handle the load.


## Results thus far

 Looking at the results so far it would seem that the new c6gn EC2 performs slightly worse than current generation c5 EC2 at the upper end of the request counts. The c6gn performes the same on the lower end of the requests count and has a higher maximum load as it did not crash when the request count hit 1200 per second. However, on the upper end of that range e.g. 1000 and 1100 requests per second the c5 is able to out perform the c6gn in almost every latency value. As these results are not conclusive I will perform some more tests with a longer timeframe to see how each EC2 stands up.
 
 ### Vegeta config

	echo "GET endpoint" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=X -workers=20 | vegeta report
	
For these tests, I had to remove the output to the results.bin as this was causing disk space to run out when running the tests.

## Tests

We conducted tests at 800, 1000, 1100 and 1200 requests per second, for 300 seconds.

### Test 6 - 800 requests per second

##### c6gn EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=800 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  240000, 800.00, 799.72
    Duration      [total, attack, wait]      5m0.106587969s, 4m59.99892329s, 107.664679ms
    Latencies     [mean, 50, 95, 99, max]    109.336259ms, 108.510104ms, 114.053289ms, 121.801447ms, 239.833349ms
    Bytes In      [total, mean]              49152000000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:240000  
    Error Set:

##### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=800 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  240000, 800.00, 799.72
    Duration      [total, attack, wait]      5m0.106530858s, 4m59.9987461s, 107.784758ms
    Latencies     [mean, 50, 95, 99, max]    108.123967ms, 107.954952ms, 110.119924ms, 111.502978ms, 136.281032ms
    Bytes In      [total, mean]              49152000000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:240000  
    Error Set:

##### Test 6 summary
Again, at the mid range request rate, both the EC2s perform similarly with an average response rate of around 109ms but, the c6gn does have a reasonable increase on the maximum value.
### Test 7 - 1000 requests per second

##### c6gn EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1000 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  299999, 999.30, 998.78
    Duration      [total, attack, wait]      5m0.365989888s, 5m0.208115202s, 157.874686ms
    Latencies     [mean, 50, 95, 99, max]    166.323102ms, 133.53357ms, 333.500666ms, 492.531194ms, 1.13323026s
    Bytes In      [total, mean]              61439795200, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:299999  
    Error Set:

##### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1000 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  299994, 999.75, 999.33
    Duration      [total, attack, wait]      5m0.19489962s, 5m0.068254994s, 126.644626ms
    Latencies     [mean, 50, 95, 99, max]    170.11644ms, 152.595538ms, 292.036631ms, 360.473944ms, 569.791361ms
    Bytes In      [total, mean]              61438771200, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:299994  
    Error Set:


##### Test 7 summary
This test has similar results to test 6 where the mean latency is very similar however in this case the maximum latency for the c6gn is around double that of the c5.

### Test 8 - 1100 requests per second

##### c6gn EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1100 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  329997, 1099.29, 1098.29
    Duration      [total, attack, wait]      5m0.465073507s, 5m0.191497792s, 273.575715ms
    Latencies     [mean, 50, 95, 99, max]    481.852676ms, 448.259106ms, 904.631774ms, 1.093093496s, 1.760843975s
    Bytes In      [total, mean]              67583385600, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:329997  
    Error Set:

##### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1100 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  329993, 1099.93, 1099.28
    Duration      [total, attack, wait]      5m0.189352626s, 5m0.012432319s, 176.920307ms
    Latencies     [mean, 50, 95, 99, max]    232.481997ms, 215.069426ms, 405.139616ms, 499.883433ms, 1.149220473s
    Bytes In      [total, mean]              67582566400, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:329993  
    Error Set:

##### Test 8 summary
This is were the results start to differ rather a lot. The mean latency of th c6gn is over double that of the c5 and the same is for the maximum latency.

### Test 9 - 1200 requests per second

##### c6gn EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1200 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  359983, 1199.46, 1197.98
    Duration      [total, attack, wait]      5m0.492553361s, 5m0.119916682s, 372.636679ms
    Latencies     [mean, 50, 95, 99, max]    666.141008ms, 622.332401ms, 1.189598773s, 1.43579222s, 2.514235414s
    Bytes In      [total, mean]              73724518400, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:359983  
    Error Set:

##### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1200 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  359997, 1199.99, 920.62
    Duration      [total, attack, wait]      5m0.286113228s, 4m59.999618884s, 286.494344ms
    Latencies     [mean, 50, 95, 99, max]    266.357934ms, 261.157476ms, 581.788876ms, 810.369614ms, 5.251460064s
    Bytes In      [total, mean]              56621779064, 157284.03
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    76.79%
    Status Codes  [code:count]               0:81778  200:276450  500:1769  
    Error Set:
    Get http://10.114.152.121:7080/foobar: EOF
    500 Internal Server Error

##### Test 9 summary
Looking at the latencies you would believe the c5 outperformed the c6gn however looking at the status codes returned you can actually see that the c5 returned a lot of error status codes and on top of this alarms for HTTPRequestFailed, CircuitBreakerActive and HighCPUUsage whereas even though the c6gn did have reasonably slow latencies, it did not crash and all responses were 200s.

## Results
I think the overall results are now very similar to what we saw in the first set of tests. In the mid to low ranges of request rate both the c6gn and c5 EC2 have the same performance however, as you begin to move to high request rates e.g. 1000+ the c5 EC2 performs better but has a lower ceiling meaning it will crash sooner compared to the c6gn as the request rate increases. 