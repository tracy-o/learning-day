Code.require_file("formatter/joe_formatter.ex", __DIR__)
Code.require_file("smoke/belfrage_smoke_test_case.ex", __DIR__)

# We set up Mox stubs here before starting the app because some of the
# processes in the app use mocked modules right after starting (e.g.
# `Belfrage.Credentials.Refresh`) and if we don't set up stubs before starting
# the app those processes will crash because the mocked modules won't be
# expecting any function calls. We also enable global mode in Mox because
# stubbed modules will be used by app's processes, not this process.
:ok = Application.start(:mox)
Test.Support.Helper.setup_stubs()
Mox.set_mox_global()

# We start the app manually here because we would like to be able to setup Mox
# stubs before it starts. This is also why we've got `mix test` alias in
# `mix.exs` which adds a `--no-start` parameter: we don't want Mix to start the
# app for us when we run tests.
{:ok, _apps} = Application.ensure_all_started(:belfrage)

production_environment = Application.get_env(:belfrage, :production_environment)

# recompile route files for only_on tests
# for matching environments
Application.put_env(:belfrage, :production_environment, "some_environment")
Code.compile_file("test/support/mocks/routefile_only_on_mock.exs")

# for non matching environments
Application.put_env(:belfrage, :production_environment, "some_other_environment")
Code.compile_file("test/support/mocks/routefile_only_on_multi_env_mock.exs")

Application.put_env(:belfrage, :production_environment, production_environment)

ExUnit.start(case_load_timeout: 120_000, timeout: 120_000, capture_log: true)
