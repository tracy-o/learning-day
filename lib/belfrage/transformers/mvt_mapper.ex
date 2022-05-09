defmodule Belfrage.Transformers.MvtMapper do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Mvt

  @dial Application.get_env(:belfrage, :dial)

  @platform_mapping %{Webcore => "1", MozartSimourgh => "2"}

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    slot =
      Mvt.Slots.available()
      |> Map.get(@platform_mapping[struct.private.platform], [])

    struct =
      if @dial.state(:mvt_enabled) do
        Struct.add(struct, :private, %{mvt: map_mvt_headers(raw_headers, slot)})
      else
        struct
      end

    then_do(rest, struct)
  end

  defp map_mvt_headers(headers, slot) do
    1..20
    |> Enum.map(fn i -> {i, header_parts(i, headers)} end)
    |> Enum.filter(&in_slot?(&1, slot))
    |> Enum.into(%{}, fn {i, [type, name, value]} ->
      {"mvt-#{name}", {i, "#{type};#{value}"}}
    end)
  end

  defp header_parts(i, headers) do
    (headers["bbc-mvt-#{i}"] || "") |> String.split(";")
  end

  defp in_slot?({i, parts}, slot) do
    case parts do
      [_type, experiment_name, _value] ->
        Enum.any?(slot, &(&1["header"] == "bbc-mvt-#{i}" and &1["key"] == experiment_name))

      _ ->
        false
    end
  end
end
