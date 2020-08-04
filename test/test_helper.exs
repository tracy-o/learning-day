Code.require_file("formatter/joe_formatter.ex", __DIR__)
Code.require_file("smoke/belfrage_smoke_test_case.ex", __DIR__)

:ok = Application.start(:mox)

Test.Support.Helper.setup_stubs()

{:ok, _apps} = Application.ensure_all_started(:belfrage)

ExUnit.start()
