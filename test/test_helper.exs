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

ExUnit.start(case_load_timeout: 120_000, timeout: 120_000, capture_log: true)
