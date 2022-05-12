defmodule Belfrage.Transformers.MvtMapper do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Mvt

  @dial Application.get_env(:belfrage, :dial)

  @platform_mapping %{Webcore => "1", Simorgh => "2"}

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    project_slots =
      Mvt.Slots.available()
      |> Map.get(@platform_mapping[struct.private.platform], [])

    struct =
      if @dial.state(:mvt_enabled) do
        Struct.add(struct, :private, %{mvt: map_mvt_headers(raw_headers, project_slots)})
      else
        struct
      end

    then_do(rest, struct)
  end

  defp map_mvt_headers(headers, project_slots) do
    1..20
    |> Enum.map(fn i -> {i, header_parts(i, headers)} end)
    |> Enum.filter(fn {i, parts} -> valid_parts?(parts, i, project_slots) end)
    |> Enum.into(%{}, fn {i, [type, name, value]} ->
      {"mvt-#{name}", {i, "#{type};#{value}"}}
    end)
  end

  defp header_parts(i, headers) do
    (headers["bbc-mvt-#{i}"] || "") |> String.split(";")
  end

  defp valid_parts?(parts, i, project_slots) do
    case parts do
      [_type, slot_name, _value] ->
        Enum.any?(project_slots, fn slot -> match_slot?(slot, i, slot_name) end)

      _ ->
        false
    end
  end

  defp match_slot?(slot, i, slot_name) do
    slot["header"] == "bbc-mvt-#{i}" and slot["key"] == slot_name
  end
end
