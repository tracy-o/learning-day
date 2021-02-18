Code.require_file("formatter/joe_formatter.ex", __DIR__)
Code.require_file("smoke/belfrage_smoke_test_case.ex", __DIR__)

:ok = Application.start(:mox)

Test.Support.Helper.setup_stubs()

if Mix.env() == :end_to_end do
  Mox.set_mox_global()
end

{:ok, _apps} = Application.ensure_all_started(:belfrage)

ExUnit.start([{:case_load_timeout, 120_000}, {:timeout, 120_000}])
