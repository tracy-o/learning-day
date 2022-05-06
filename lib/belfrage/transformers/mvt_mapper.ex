defmodule Belfrage.Transformers.MvtMapper do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Mvt

  @dial Application.get_env(:belfrage, :dial)

  @platform_mapping %{Webcore => "1", MozartSimourgh => "2"}

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    struct =
      if @dial.state(:mvt_enabled) do
        Struct.add(struct, :private, %{mvt: map_mvt_headers(raw_headers, struct.private.platform)})
      else
        struct
      end

    then_do(rest, struct)
  end

  defp map_mvt_headers(headers, platform) do
    slot = get_slot(platform)

    1..20
    |> Enum.map(fn i -> {i, header_parts(i, headers)} end)
    |> Enum.filter(&in_slot?(&1, slot))
    |> Enum.into(%{}, fn {i, [type, name, value]} ->
      {"mvt-#{name}", {i, "#{type};#{value}"}}
    end)
  end

  defp in_slot?({i, parts}, slot) do
    case parts do
      [_type, name, _value] -> match_slot?("bbc-mvt-#{i}", name, slot)
      _ -> false
    end
  end

  defp header_parts(i, headers) do
    (headers["bbc-mvt-#{i}"] || "") |> String.split(";")
  end

  defp match_slot?(header, experiment, slot) do
    Enum.any?(slot, fn e -> e["header"] == header and e["key"] == experiment end)
  end

  defp get_slot(platform) do
    Mvt.Slots.available()
    |> Map.get(slot_key(platform), [])
  end

  defp slot_key(platform), do: Map.get(@platform_mapping, platform)
end
