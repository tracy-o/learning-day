# Test results: Comparing the new c6g.2xlarge EC2 to the c5.2xlarge EC2

## Context

Amazon Web Services have recently released their new C6 generation of EC2 which are powered by Arm-based AWS Graviton2 processors, "They deliver up to 40% better price performance over current generation C5 instances".

The specific instances we will be testing is the c6g instance.
[c6g instance type](https://aws.amazon.com/ec2/instance-types/c6/)

## Hypotheses

When compared to the current c5.2xlarge EC2:
1. The use of c6g.2xlarge instance incurs less traffic latency
2. The new c6g.2xlarge EC2 maintains a higher proportion of success status codes

## Setup

- To verify the performance of the c6g instance we will use Vegeta and Origin Simulator. Vegeta will allow us to send a consistent and accurate stream of requests to Belfrage which will then send requests upstream to Origin Simulator.
- We will be varying the rate of requests per second and attack time using Vegeta 
- We have created a standalone c6g EC2 instance on which we then installed belfrage
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

### Test 1 - 400 requests per second

#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=400 -workers=20 | tee results.bin | vegeta report
    Requests      [total, rate, throughput]  24000, 400.02, 399.31
    Duration      [total, attack, wait]      1m0.103771332s, 59.997441443s, 106.329889ms
    Latencies     [mean, 50, 95, 99, max]    107.381249ms, 107.344525ms, 108.037064ms, 108.738144ms, 156.705088ms
    Bytes In      [total, mean]              4915200000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:24000  
    Error Set:
    
#### c5 EC2
    echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=400 -workers=20 | tee results.bin | vegeta report
    Requests      [total, rate, throughput]  24000, 400.01, 399.30
    Duration      [total, attack, wait]      1m0.105059575s, 59.997910334s, 107.149241ms
    Latencies     [mean, 50, 95, 99, max]    107.30513ms, 107.242312ms, 108.059444ms, 108.725476ms, 145.193336ms
    Bytes In      [total, mean]              4915200000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:24000  
    Error Set:

#### Test 1 summary

As you can see the latency results are very similar for both EC2s which is what we would expect with request rate on the lower end.

### Test 2 - 800 requests per second

#### c6g EC2
	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=800 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  48000, 800.02, 798.58
    Duration      [total, attack, wait]      1m0.106819828s, 59.998701111s, 108.118717ms
    Latencies     [mean, 50, 95, 99, max]    110.198792ms, 108.264672ms, 113.048957ms, 176.317378ms, 280.116858ms
    Bytes In      [total, mean]              9830400000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:48000  
    Error Set:  

#### c5 EC2
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
#### c6g EC2

	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1000 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  59999, 999.98, 998.18
    Duration      [total, attack, wait]      1m0.108335314s, 1m0.000220974s, 108.11434ms
    Latencies     [mean, 50, 95, 99, max]    121.984066ms, 110.354221ms, 175.199055ms, 353.359977ms, 664.771697ms
    Bytes In      [total, mean]              12287795200, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:59999  
    Error Set:

#### c5 EC2
  
	echo "GET http://10.114.174.40:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1000 -workers=20 | tee results.bin | vegeta report
	Requests      [total, rate, throughput]  60000, 1000.02, 998.19
	Duration      [total, attack, wait]      1m0.109018107s, 59.998989623s, 110.028484ms
	Latencies     [mean, 50, 95, 99, max]    140.907604ms, 115.081379ms, 247.647949ms, 319.522556ms, 494.719319ms
	Bytes In      [total, mean]              12288000000, 204800.00
	Bytes Out     [total, mean]              0, 0.00
	Success       [ratio]                    100.00%
	Status Codes  [code:count]               200:60000  
	Error Set:
	
#### Test 3 summary

This test is again following the trend for test 2, both the c5 and c6g are similar in almost every lantency value.

### Test 4 - 1100 requests per second

#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1100 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  65998, 1099.97, 1096.19
    Duration      [total, attack, wait]      1m0.206871522s, 59.999768801s, 207.102721ms
    Latencies     [mean, 50, 95, 99, max]    266.011556ms, 237.36033ms, 541.013711ms, 705.686442ms, 1.131122817s
    Bytes In      [total, mean]              13516390400, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:65998  
    Error Set:

#### c5 EC2
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

This test shows the c5 EC2 sligthly outperforming the c6g in all latency values.

### Test 5 - 1200 requests per second

#### c6g EC2
	echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=60s -rate=1200 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  71997, 1197.32, 1184.81
    Duration      [total, attack, wait]      1m0.766668814s, 1m0.131548049s, 635.120765ms
    Latencies     [mean, 50, 95, 99, max]    605.518715ms, 572.137425ms, 1.092959832s, 1.319142254s, 1.817744862s
    Bytes In      [total, mean]              14744985600, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:71997  
    Error Set:

#### c5 EC2
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

#### Test 5 summary

Looking at the latency results you may believe the c5 drastically out performed the c6g however this is not the case, as you can see over 70,000 of the 72,000 requests sent were 500s meaning the c5 was unable to handle the load.


## Results thus far

Hypotheses:
When compared to the current c5.2xlarge EC2:
1. The use of c6g.2xlarge instance incurs less traffics latency
2. The new c6g.2xlarge EC2 maintains a higher proportion of success status codes

The c6g performes the same on the lower end of the requests count and has a higher maximum load as it did not crash when the request count hit 1200 per second. However, on the upper end of that range e.g. 1000 and 1100 requests per second the c5 is able to out perform the c6g in almost every latency value. This would lead us to disagree with my first hypothesis as most latency values were the same for each test and agree with the second hypothesis as we can see that the c6g is able to withstand more load, maintaining a higher proportion of success status codes.

As these results are not conclusive and only run for 60 secondsI will perform some more tests with a longer timeframe to see how each EC2 stands up.
 
 ### Vegeta config

	echo "GET endpoint" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=X -workers=20 | vegeta report
	
For these tests, I had to remove the output to the results.bin as this was causing disk space to run out when running the tests.

## Tests

We conducted tests at 800, 1000, 1100 and 1200 requests per second, for 300 seconds.

### Test 6 - 800 requests per second

#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=800 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  240000, 800.00, 799.72
    Duration      [total, attack, wait]      5m0.106528249s, 4m59.998903165s, 107.625084ms
    Latencies     [mean, 50, 95, 99, max]    109.567159ms, 108.729791ms, 115.14348ms, 121.911397ms, 169.80185ms
    Bytes In      [total, mean]              49152000000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:240000  
    Error Set:

#### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=800 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  240000, 800.00, 799.72
    Duration      [total, attack, wait]      5m0.106530858s, 4m59.9987461s, 107.784758ms
    Latencies     [mean, 50, 95, 99, max]    108.123967ms, 107.954952ms, 110.119924ms, 111.502978ms, 136.281032ms
    Bytes In      [total, mean]              49152000000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:240000  
    Error Set:

#### Test 6 summary
Again, at the mid range request rate, both the EC2s perform similarly with an average response rate of around 109ms.

### Test 7 - 1000 requests per second

#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1000 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  300000, 999.93, 999.57
    Duration      [total, attack, wait]      5m0.128893097s, 5m0.01962356s, 109.269537ms
    Latencies     [mean, 50, 95, 99, max]    136.725024ms, 118.031817ms, 221.080201ms, 293.072961ms, 763.888565ms
    Bytes In      [total, mean]              61440000000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:300000  
    Error Set:

#### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1000 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  299994, 999.75, 999.33
    Duration      [total, attack, wait]      5m0.19489962s, 5m0.068254994s, 126.644626ms
    Latencies     [mean, 50, 95, 99, max]    170.11644ms, 152.595538ms, 292.036631ms, 360.473944ms, 569.791361ms
    Bytes In      [total, mean]              61438771200, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:299994  
    Error Set:


#### Test 7 summary
This test has similar results to the previous with latency values being similar.

### Test 8 - 1100 requests per second

#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1100 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  329995, 1099.72, 1099.32
    Duration      [total, attack, wait]      5m0.180227613s, 5m0.072739279s, 107.488334ms
    Latencies     [mean, 50, 95, 99, max]    348.464125ms, 292.938338ms, 768.625232ms, 1.000620108s, 1.649375683s
    Bytes In      [total, mean]              67582976000, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:329995  
    Error Set:

#### c5 EC2
    echo "GET http://10.114.152.121:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1100 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  329993, 1099.93, 1099.28
    Duration      [total, attack, wait]      5m0.189352626s, 5m0.012432319s, 176.920307ms
    Latencies     [mean, 50, 95, 99, max]    232.481997ms, 215.069426ms, 405.139616ms, 499.883433ms, 1.149220473s
    Bytes In      [total, mean]              67582566400, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:329993  
    Error Set:

#### Test 8 summary
This is were the results start to differ rather a lot. The mean latency of th c6g is 1.5x that of the c5 and the same is for the maximum latency.

### Test 9 - 1200 requests per second

#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1200 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  359989, 1199.36, 1197.67
    Duration      [total, attack, wait]      5m0.574195261s, 5m0.151027972s, 423.167289ms
    Latencies     [mean, 50, 95, 99, max]    576.892204ms, 535.794257ms, 1.032659669s, 1.255504185s, 1.966969846s
    Bytes In      [total, mean]              73725747200, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:359989  
    Error Set:

#### c5 EC2
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

#### Test 9 summary
Looking at the latencies you would believe the c5 outperformed the c6g however looking at the status codes returned you can actually see that the c5 returned a lot of error status codes and on top of this alarms for HTTPRequestFailed, CircuitBreakerActive and HighCPUUsage whereas even though the c6g did have reasonably slow latencies, it did not crash and all responses were 200s.

## More testing
We also decided that now we have reached the ceiling for requests per second (1200) on the c5 EC2 at which point it begins to return multiple 500s, it might be valuable to see how much more load the c6g can handle. We also wanted to plot some of the results using Vegta graphs to get a more graphical idea of how the EC2 instances are perfoming against one another

### Test 10 - 1000 requests per second
We used the vegeta-300s-1000rps belfrage-wrk2-loadtest [recipe](https://github.com/bbc/belfrage-wrk2-loadtest/blob/master/trigger/recipes/vegeta-300s-1000rps.json) as this is the point at which the instances begin to differ in results.

#### c6g EC2
[results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-300s-1000rps-c6g/)

#### c5 EC2
[results](https://broxy.tools.bbc.co.uk/belfrage-loadtest-results/vegeta-300s-1000rps-c5/)

### Test 11 - 1300 requests per second
#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1300 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  390001, 1300.00, 1296.80
    Duration      [total, attack, wait]      5m0.740774325s, 4m59.999753547s, 741.020778ms
    Latencies     [mean, 50, 95, 99, max]    1.09327626s, 993.744096ms, 2.135436456s, 2.701838089s, 5.085046097s
    Bytes In      [total, mean]              79872204800, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:390001  
    Error Set:
    
### Test 12 - 1400 requests per second
#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1400 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  419998, 1398.62, 1391.76
    Duration      [total, attack, wait]      5m1.774578055s, 5m0.294458351s, 1.480119704s
    Latencies     [mean, 50, 95, 99, max]    1.725042321s, 1.593460504s, 3.296713521s, 4.223014502s, 8.084847435s
    Bytes In      [total, mean]              86015590400, 204800.00
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    100.00%
    Status Codes  [code:count]               200:419998  
    Error Set:
    
### Test 13 - 1500 requests per second
#### c6g EC2
    echo "GET http://10.114.134.180:7080/foobar" | vegeta attack -header="replayed-traffic: true" -duration=300s -rate=1500 -workers=20 | vegeta report
    Requests      [total, rate, throughput]  449915, 1495.34, 1342.60
    Duration      [total, attack, wait]      5m5.826541857s, 5m0.878179981s, 4.948361876s
    Latencies     [mean, 50, 95, 99, max]    3.789552451s, 3.377730977s, 8.701736541s, 11.303297558s, 21.749549011s
    Bytes In      [total, mean]              84091494452, 186905.29
    Bytes Out     [total, mean]              0, 0.00
    Success       [ratio]                    91.26%
    Status Codes  [code:count]               0:2  200:410603  500:39310  
    Error Set:
    Get http://10.114.134.180:7080/foobar: http: server closed idle connection
    500 Internal Server Error

### More testing summary
As you can see the c6g is able to handle up to 1400 requests per second for 300 seconds before starting to return many 500 status codes at 1500 requests per second.

## Results
I think the overall results are now very similar to what we saw in the first set of tests. 

In the mid to low ranges of request rate both the c6g and c5 EC2 have the same performance. However, as you begin to move to high request rates e.g. 1000+ the c5 EC2 performs better but has a lower ceiling meaning it will crash sooner compared to the c6g as the request rate increases. 

When looking back at out Hypotheses,when compared to the current c5.2xlarge EC2:
1. The use of c6g.2xlarge instance incurs less traffics latency
2. The new c6g.2xlarge EC2 maintains a higher proportion of success status codes

We can come to the conclusion that we disagree with our first hypothesis as for most of the tests both instances performed the same and as the request rates got close to the c5 EC2 ceiling (1000-1100) the c5 actually performed slightly better.

We can also conclude that we agree with our second hypothesis as the c6g EC2 was able to miantain a higher proportion of success status codes when using higher request rates. The c6g was able to miantain correctness up to 1500 requests per second.
