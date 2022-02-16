IO.puts("defmodule Belfrage.Transformers.LocalNewsTopicsRedirect.LocationTopicMappings do")

for n <- 1..17_000 do
  case n do
    1 ->
      IO.puts("@location_topic_mappings [ {:\"#{n}\", #{n}},")

    17_000 ->
      IO.puts("  {:\"#{n}\", #{n}} ]")

    _ ->
      IO.puts("  {:\"#{n}\", #{n}},")
  end
end

IO.puts("""

  def get_topic_id(location_id) do
    Keyword.get(@location_topic_mappings, location_id)
  end

""")

IO.puts("end")
