defmodule Belfrage.Mvt.Mapper do
  alias Belfrage.Mvt
  alias Belfrage.Struct

  @dial Application.get_env(:belfrage, :dial)

  @platform_mapping %{Webcore => "1", Simorgh => "2"}

  def map(struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    if @dial.state(:mvt_enabled) do
      project_slots =
        Mvt.Slots.available()
        |> Map.get(@platform_mapping[struct.private.platform], [])

      mvt_map =
        Map.merge(
          map_mvt_headers(raw_headers, project_slots),
          map_override_headers(raw_headers)
        )

      Struct.add(struct, :private, %{mvt: mvt_map})
    else
      struct
    end
  end

  defp map_mvt_headers(headers, project_slots) do
    1..20
    |> Enum.map(fn i -> {i, header_parts(i, headers)} end)
    |> Enum.filter(fn {i, parts} -> valid_parts?(parts, i, project_slots) end)
    |> Enum.into(%{}, fn {i, [type, name, value]} ->
      {"mvt-#{name}", {i, "#{type};#{value}"}}
    end)
  end

  defp map_override_headers(headers) do
    if test_env?() do
      headers
      |> Enum.filter(fn {name, _v} -> match?(<<"mvt-", _rest::binary>>, name) end)
      |> Enum.into(%{}, fn {name, value} -> {name, {:override, value}} end)
    else
      %{}
    end
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

  defp test_env?() do
    Application.get_env(:belfrage, :production_environment) == "test"
  end
end
