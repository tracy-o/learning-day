:ok = Application.start(:mox)

Test.Support.Helper.setup_stubs()

{:ok, _apps} = Application.ensure_all_started(:belfrage)

case Mix.env() do
  :test ->
    ExUnit.configure(exclude: [:end_to_end, :routes_test, :smoke_test])

  :end_to_end ->
    ExUnit.configure(include: [:end_to_end], exclude: [:test, :routes_test, :smoke_test])

  _ ->
    ExUnit.configure([])
end

ExUnit.start()
