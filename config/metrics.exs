use Mix.Config

config :ex_metrics,
  metrics: [
    "function.timing.service.lambda.invoke",
    "service.lamda.response.200",
    "service.lamda.response.403",
    "service.lamda.response.404",
    "service.lamda.response.408", # dynamic/programmed way to define these? Or don't bother?
    "service.lamda.response.500",
    "error.loop.threshold.exceeded",
    "error.loop.state",
    "error.pipeline.process",
    "error.pipeline.process.redirect",
    "error.pipeline.process.unhandled"
  ]
