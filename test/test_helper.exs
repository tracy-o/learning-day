Code.require_file("formatter/joe_formatter.ex", __DIR__)
Code.require_file("smoke/belfrage_smoke_test_case.ex", __DIR__)

ExUnit.start(case_load_timeout: 120_000, timeout: 120_000, capture_log: true)
