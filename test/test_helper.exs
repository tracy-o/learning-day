case Mix.env() do
  :test ->
    ExUnit.configure(exclude: [:end_to_end])

  :end_to_end ->
    ExUnit.configure(include: [:end_to_end], exclude: [:test])
end

ExUnit.start()
