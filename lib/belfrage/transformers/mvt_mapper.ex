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

  def map_mvt_headers(req_headers, platform) do
    slot = get_slot(platform)

    reduction = fn i, acc ->
      with [type, name, value] <- header_parts(req_headers, "bbc-mvt-#{i}"),
           true <- match_slot?("bbc-mvt-#{i}", name, slot) do
        Map.merge(acc, %{"mvt-#{name}" => {i, "#{type};#{value}"}})
      else
        _err -> acc
      end
    end

    Enum.reduce(1..20, %{}, reduction)
  end

  defp header_parts(req_headers, header_name) do
    (req_headers[header_name] || "") |> String.split(";")
  end

  defp match_slot?(header_name, experiment_name, slot) do
    Enum.any?(slot, fn e -> e["header"] == header_name and e["key"] == experiment_name end)
  end

  defp get_slot(platform) do
    Mvt.Slots.available()
    |> Map.get(slot_key(platform), [])
  end

  defp slot_key(platform), do: Map.get(@platform_mapping, platform)
end
