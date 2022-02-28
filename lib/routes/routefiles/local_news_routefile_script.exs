IO.puts("defmodule Belfrage.Transformers.LocalNewsTopicsRedirect.LocationTopicMappings do")

for n <- 1..17_000 do
  cond do
    n == 1 ->
      IO.puts("@location_topic_mappings %{ \"#{n}\" => #{n},")

    n == 17_000 ->
      IO.puts("  \"#{n}\" => 17_000 }")

    n >= 10_000 ->
      <<first_two_digits::bytes-size(2), rest::binary>> = "#{n}"
      IO.puts("  \"#{n}\" => #{first_two_digits}_#{rest},")

    true ->
      IO.puts("  \"#{n}\" => #{n},")
  end
end

IO.puts("""

  def get_topic_id(location_id) do
    Map.get(@location_topic_mappings, location_id)
  end

""")

IO.puts("end")
