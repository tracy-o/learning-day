Code.require_file("formatter/joe_formatter.ex", __DIR__)
Code.require_file("smoke/belfrage_smoke_test_case.ex", __DIR__)

:ok = Application.start(:mox)

Test.Support.Helper.setup_stubs()

Mox.set_mox_global()

if Mix.env() == :end_to_end do
  Mox.set_mox_global()
end

{:ok, _apps} = Application.ensure_all_started(:belfrage)

production_environment = Application.get_env(:belfrage, :production_environment)

# recompile route files for only_on tests
# for matching environments
Application.put_env(:belfrage, :production_environment, "some_environment")
Code.compile_file("test/support/mocks/routefile_only_on_mock.ex")

# for non matching environments
Application.put_env(:belfrage, :production_environment, "some_other_environment")
Code.compile_file("test/support/mocks/routefile_only_on_multi_env_mock.ex")

Application.put_env(:belfrage, :production_environment, production_environment)

ExUnit.start([{:case_load_timeout, 120_000}, {:timeout, 120_000}])
