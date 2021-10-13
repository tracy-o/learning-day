# Investigating our Approach

In this document:

- Outline where we use Xray in the Belfrage codebase
- Explore the limitations of the aws_ex_ray library
- Explore how we can avoid error responses in Belfrage, when Xray produces an error

## What is AWS Xray? (Just a Refresher)

X-Ray enables developers to analyse and debug applications built on AWS.
It can be used across distributed applications to track data as it passes through.

To do this X-Ray uses a trace.

- A trace can be comprised of one or more segments.
- Each Segment can also be divided into one or more subsegments
- Each sub-segment contains data such as a timestamp, query, status code
- This data is then sent to the xray daemon (via [aws_ex_ray](https://github.com/lyokato/aws_ex_ray)) which interacts with AWS X-Ray API

## Where is Xray Used in Belfrage?

- [`belfrage/xray.ex` (link)](https://github.com/bbc/belfrage/blob/87754708b8de461c06f6cc189b6d4bf09cfe0ab0/lib/xray.ex) - This module is a wrapper around the [AwsExRaylibrary](https://github.com/lyokato/aws_ex_ray).
  <br>

- [`belfrage_web/plugs/xray.ex` (link)](https://github.com/bbc/belfrage/blob/87754708b8de461c06f6cc189b6d4bf09cfe0ab0/lib/belfrage_web/plugs/xray.ex)

  - This does 3 main things: - creates, starts and stops the xray tracing - attaches data to the trace (also called segment) such as `request_id` `method` and `request path` - puts the `:xray_trace_id` in the `conn.private` (`:xray_trace_id` contains the `id` of the trace and weather the trace should be sampled or not)
    <br>

- [`belfrage_web/struct_adaptor.ex` (link)](https://github.com/bbc/belfrage/blob/f6eaf776880a0c258384b01059e49fa56d1766bf/lib/belfrage_web/struct_adapter.ex)

  - Here the `:xray_trace_id` is taken from `conn.private` and placed in `struct.request`
    <br>

- [`belfrage/clients/lambda.ex` (link)](https://github.com/bbc/belfrage/blob/87754708b8de461c06f6cc189b6d4bf09cfe0ab0/lib/belfrage/clients/lambda.ex)
  - here a trace subsegment is created measuring the time it takes to invoke and receive a response from the lambda.
  - Side note: why are we using `require Xray` here rather than using @xray from application env?
    <br>
- [`belfrage/services/fabl.ex` (link)](https://github.com/bbc/belfrage/blob/f6eaf776880a0c258384b01059e49fa56d1766bf/lib/belfrage/services/fabl.ex)
  - `:xray_trace_id` is taken from the `struct` and put into requests that we send to fabl.

## How Does the Library We Use Function?

We use the [aws_ex_ray](https://github.com/lyokato/aws_ex_ray) library in belfrage to handle our requests to interface with X-Ray.

This library functions by creating an ETS table which is bound to the process which calls `start_tracing` (in our case each request process). This keeps track of the segments and subsegments of each request. When the tracing is finished it is sent to the xray daemon (on the instance) via a UDP client.

### Limitations of the Library
#### ETS Pool Timeout
Under particularly high load this library has been coming under strain. This has been observed during recent load test [see here](https://github.com/bbc/belfrage/blob/f6a7a093f051167f6017f983c4f92d17420e6aa5/docs/load-test-results/2021-09-20-testing-finch-http-client.md). The whole error is underneath.

```
{"datetime":"2021-09-22T07:17:18.671042Z","kind":"exit","level":"error","metadata":{"request_id":"648198ee846844d3bfbf3482c2f11681"},"msg":"Router Service returned a 500 status","query_string":"","reason":["timeout",["gen_server","call",["aws_ex_store_pool",["checkout","#Ref<>",true],5000]]],"request_path":"/sam","stack":"    (stdlib 3.14) gen_server.erl:246: :gen_server.call/3\n    (poolboy 1.5.2) /home/sam_french/belfrage/deps/poolboy/src/poolboy.erl:63: :poolboy.checkout/3\n    (poolboy 1.5.2) /home/sam_french/belfrage/deps/poolboy/src/poolboy.erl:82: :poolboy.transaction/3\n    (aws_ex_ray 0.1.16) lib/aws_ex_ray/store/monitor_supervisor.ex:17: AwsExRay.Store.MonitorSupervisor.start_monitoring/1\n    (aws_ex_ray 0.1.16) lib/aws_ex_ray.ex:258: AwsExRay.start_tracing/2\n    (belfrage 0.2.0) lib/belfrage_web/plugs/xray.ex:23: BelfrageWeb.Plugs.XRay.call/2\n    (belfrage 0.2.0) lib/belfrage_web/router.ex:1: BelfrageWeb.Router.plug_builder_call/2\n    (belfrage 0.2.0) lib/plug/error_handler.ex:65: BelfrageWeb.Router.call/2\n"}
```

Under closer inspection we see:
```
"reason":["timeout",["gen_server","call",["aws_ex_store_pool",["checkout","#Ref<>",true],5000]]]
```

This shows that while under extreme load the ETS is being written to faster than it can handle. The result of this is that the pool workers that are used to access the ETS are timing out, causing this error.

For more detail see these modules in the library:
[AwsExRay](https://github.com/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray.ex#L258)
[AwsExRay.Store.MonitorSupervisor](https://github.com/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray/store/monitor_supervisor.ex#L16-L21)
[AwsExRay.Store.ProcessMonitor](https://github.com/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray/store/process_monitor.ex#L14)

### Inefficient Sampling
As X-Ray is designed for production applications it would be ludicrous to send a trace of every request to the X-Ray API. Therefore there is a concept of sampling. In our case we have a sample rate of 0.1 or 1 in 10 requests.

However, [aws_ex_ray](https://github.com/lyokato/aws_ex_ray)'s approach to sampling is not particularly elegant. Below we can see why.

When a trace is created it is decided whether it should be traced or not . 
```elixir

defmodule AwsExRay.Trace do
...

def new() do
  %__MODULE__{
    root:    Util.generate_trace_id(),
    sampled: Util.sample?(),
    parent:  "",
  }
  end
...

end
```
[link to code](https://github.com/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray/trace.ex#L21-L28)

If the trace is not destined to be sampled **its still treated the same** as a request that will be sampled. The distinction is only made when the trace is finished. A check is made to see if the trace is supposed to be sampled before being sent to the X-Ray daemon.

```elixir
defmodule AwsExRay do
...

  def finish_tracing(segment) do

    segment = segment
           |> Segment.finish()

    if Segment.sampled?(segment) do
      segment
      |> Segment.to_json()
      |> Client.send()
    end

    Store.Table.delete()
    :ok

  end
...

end
```
[link to code](https://github.com/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray.ex#L275-L292)

**This means the library could be performing 90% more work than it needs to.**

## Mitigating Impact From Errors and Degraded X-Ray Performance

If any component of the chain stops working (aws_ex_ray library, the x-ray daemon or x-ray API) we want to be sure that it doesn't impact Belfrages performance. As the collection of logs like these are purely optional. 

### Sampling Properly
If we don't call the library at all unless we wish to sample, will mean x-ray won't touch 90% of our requests. When we start tracing a request we already put the sampling information into the struct.
```elixir
def build_trace_id_header(segment) do
  sampled_value = if @xray.sampled?(segment), do: '1', else: '0'

  "Root=" <> segment.trace.root <> ";Parent=" <> segment.id <> ";Sampled=#{sampled_value}"
end
```
[link](https://github.dev/bbc/belfrage/blob/4bb3025bf9587f84334f95bab2afdda3ad21233c/lib/belfrage_web/plugs/xray.ex#L11-L16)

Before we do any tracing we could check if the request should be sampled.
Then we make all calls to the aws_ex_ray library result in a trace being sent to the AWS X-Ray API.


### Failing Fast
For the requests that are sampled, if calls to aws_ex_xray take too long we should just carry on. As aws_ex_ray makes use of pools, the longest a call to the pool to wait for a worker to be checked out is the generserver default of 5 seconds. This means in the worst case scenario this is how long we could be waiting for x-ray to respond before we produce a timeout error. If we timed out earlier we wouldn't have to wait so long in the worst case. Something like this perhaps:

```elixir
trace = timeout 1000 do
  @xray.new_trace()
end
```
This may mean the data we send to xray may not be complete, but that is much better than our requests having very slow response times. 

### What if the X-Ray Daemon or API is down?
If either of these are down there is no effect, this is because aws_ex_ray sends data to the daemon over UDP, meaning aws_ex_ray doesn't check if its messages have been received anyway. 

### What Runtime Errors Could our Library Produce?
#### Explicitly Raised
The only runtime error explicitly raised is here:

`aws_ex_ray.ex`
```elixir
def start_tracing(trace, name) do

    case Store.Table.lookup() do

      {:error, :not_found} ->
        segment = Segment.new(trace, name)
        Store.Table.insert(trace, segment.id)
        Store.MonitorSupervisor.start_monitoring(self())
        segment

      {:ok, _, _, _} ->
        raise "<AwsExRay> Tracing Context already exists on this process."
    end
  end
```
[link](https://github.dev/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray.ex#L251-L266)

Although I think this runtime error is valid, we only want to be tracing once per request, if we are something is wrong which we would want to see, not suppress.

### Other Possible Errors
We have already discussed the poolboy timeout the error that is produced from this isn't actually damaging to the application, its the time it takes to produce the error. A timeout from the pool will mean the response from the x-ray library will return a `:timeout` atom. This will mean the return value of `Store.MonitorSupervisor.start_monitoring(self())` will also be the same.

However if a runtime exception is created from pool checkout, an exception is raised in the same process as the request:

`poolboy.erl`
```erlang
checkout(Pool, Block, Timeout) ->
    CRef = make_ref(),
    try
        gen_server:call(Pool, {checkout, CRef, Block}, Timeout)
    catch
        ?EXCEPTION(Class, Reason, Stacktrace) ->
            gen_server:cast(Pool, {cancel_waiting, CRef}),
            erlang:raise(Class, Reason, ?GET_STACK(Stacktrace))
    end.
```
[link](https://github.dev/devinus/poolboy/blob/9212a8770edb149ee7ca0bca353855e215f7cba5/src/poolboy.erl#L60-L68)

`aws_ex_ray/store/monitor_supervisor.ex`
```elixir
def start_monitoring(pid) do
  # transaction calls :poolboy.checkout/3
  :poolboy.transaction(@pool_name, fn monitor ->
    ProcessMonitor.start_monitoring(monitor, pid)
  end)
  :ok
end
```
[link](https://github.dev/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray/store/monitor_supervisor.ex#L16-L21)

`aws_ex_ray.ex`
```elixir
def start_tracing(trace, name) do
  case Store.Table.lookup() do
    {:error, :not_found} ->
      segment = Segment.new(trace, name)
      Store.Table.insert(trace, segment.id)
      Store.MonitorSupervisor.start_monitoring(self())
      segment

    {:ok, _, _, _} ->
      raise "<AwsExRay> Tracing Context already exists on this process."
  end
end
```
[link](https://github.dev/lyokato/aws_ex_ray/blob/ab6e07f097d0063afb748b30155878cbb8aba60f/lib/aws_ex_ray.ex#L251-L266)

A similar class of error could also happen in ETS but is more unlikely ([see here](https://erlang.org/doc/man/ets.html#failures)).

A solution to this could be that all interaction with the x-ray library could happen in a separate process, so a runtime error from the aws_ex_ray won't touch the request process.




