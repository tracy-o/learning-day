use Mix.Config

lambda_response_code_metrics =
  Enum.map(200..599, fn status -> "service.lambda.response.#{status}" end)

http_response_code_metrics =
  Enum.map(200..599, fn status -> "service.HTTP.response.#{status}" end)

config :ex_metrics,
  metrics:
    [
      "function.timing.service.lambda.invoke",
      "function.timing.service.HTTP.request",
      "error.service.HTTP.request",
      "error.loop.threshold.exceeded",
      "error.loop.state",
      "error.pipeline.process",
      "error.pipeline.process.unhandled"
    ] ++ lambda_response_code_metrics ++ http_response_code_metrics
