# Investigating our Approach

In this document:
- Outline where we use Xray in the Belfrage codebase
- Explore how we can avoid error responses in Belfrage, when Xray produces an error

## What is AWS Xray? (Just a Refresher)

X-Ray enables developers to analyse and debug applications built on AWS.
It can be used across distributed applications to track data as it passes through.

To do this X-Ray uses a trace.
- A trace can be comprised of one or more segments.
- Each Segment can also be divided into one or more subsegments
- Each sub-segment contains data such as a timestamp, query, status code
- This data is then sent to the xray daemon which interacts with AWS X-Ray API



## Where is Xray Used in Belfrage?


-  [`belfrage/xray.ex` (link)](https://github.com/bbc/belfrage/blob/87754708b8de461c06f6cc189b6d4bf09cfe0ab0/lib/xray.ex)
    - This module is a wrapper around the [AwsExRaylibrary](https://github.com/lyokato/aws_ex_ray).
<br>

- [`belfrage_web/plugs/xray.ex` (link)](https://github.com/bbc/belfrage/blob/87754708b8de461c06f6cc189b6d4bf09cfe0ab0/lib/belfrage_web/plugs/xray.ex)
  - This does 3 main things:
    - creates, starts and stops the xray tracing
    - attaches data to the trace (also called segment) such as `request_id` `method` and `request path`
    - puts the `:xray_trace_id` in the `conn.private` (`:xray_trace_id` contains the `id` of the trace and weather the trace should be sampled or not)
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




