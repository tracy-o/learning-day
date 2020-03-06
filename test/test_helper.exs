:ok = Application.start(:mox)

Test.Support.Helper.setup_stubs()

{:ok, _apps} = Application.ensure_all_started(:belfrage)

case Mix.env() do
  :test ->
    ExUnit.configure(exclude: [:end_to_end, :routes_test])

  :end_to_end ->
    ExUnit.configure(include: [:end_to_end], exclude: [:test, :routes_test])

  :routes_test ->
    ExUnit.configure(include: [:routes_test], exclude: [:test, :end_to_end])
end

ExUnit.start()
