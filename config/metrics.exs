use Mix.Config

lambda_response_code_metrics = Enum.map(200..599, fn x -> "service.lambda.response.#{x}}" end)

config :ex_metrics,
  metrics: [
    "function.timing.service.lambda.invoke",
    "error.loop.threshold.exceeded",
    "error.loop.state",
    "error.pipeline.process",
    "error.pipeline.process.redirect",
    "error.pipeline.process.unhandled"
  ] ++ lambda_response_code_metrics
