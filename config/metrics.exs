use Mix.Config

lambda_response_code_metrics = Enum.map(200..599, fn status -> "service.lambda.response.#{status}" end)

http_response_code_metrics = Enum.map(200..599, fn status -> "service.HTTP.response.#{status}" end)

config :ex_metrics,
  metrics:
    [
      "cache.fallback_item_does_not_exist",
      "cache.stale_response_added_to_struct",
      "clients.lambda.invoke_failure",
      "clients.lambda.timeout",
      "clients.lambda.assume_role_failure",
      "clients.lambda.function_not_found",
      "error.loop.state",
      "error.pipeline.process",
      "error.pipeline.process.unhandled",
      "error.service.HTTP.request",
      "function.timing.service.HTTP.request",
      "function.timing.service.lambda.invoke"
    ] ++ lambda_response_code_metrics ++ http_response_code_metrics
