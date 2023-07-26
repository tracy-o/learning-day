if Mix.env() == :test, do: Application.ensure_all_started(:credo)
ExUnit.start(case_load_timeout: 120_000, timeout: 120_000, capture_log: true)
