# TODO The `Code.require_file/2` need to be moved from here I believe that we
# should include these files in the elixirc_path possibly like this:
#
# defp elixirc_paths(:smoke_test) do ["lib", "test/support", "test/smoke"] end

Code.require_file("smoke/expectations.ex", __DIR__)
Code.require_file("support/joe_formatter.ex", __DIR__)
Code.require_file("smoke/belfrage_smoke_test_case.ex", __DIR__)

if Mix.env() == :test, do: Application.ensure_all_started(:credo)
ExUnit.start(case_load_timeout: 120_000, timeout: 120_000, capture_log: true)
