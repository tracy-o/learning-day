:ok = Application.start(:mox)

Mox.set_mox_global()
Test.Support.Helper.setup_stubs()

{:ok, _apps} = Application.ensure_all_started(:belfrage)

case Mix.env() do
  :test ->
    ExUnit.configure(exclude: [:end_to_end])

  :end_to_end ->
    ExUnit.configure(include: [:end_to_end], exclude: [:test])
end

ExUnit.start()
