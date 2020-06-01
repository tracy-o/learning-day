:ok = Application.start(:mox)

Test.Support.Helper.setup_stubs()

{:ok, _apps} = Application.ensure_all_started(:belfrage)

ExUnit.start()
