defmodule Belfrage.Mvt.Mapper do
  alias Belfrage.Mvt
  alias Belfrage.Struct

  @dial Application.get_env(:belfrage, :dial)
  @platform_mapping %{"Webcore" => "1", "Simorgh" => "2"}
  @max_slots 20

  def map(struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    if @dial.state(:mvt_enabled) do
      project_slots =
        Mvt.Slots.available()
        |> Map.get(@platform_mapping[struct.private.platform], %{})

      mvt_map =
        %{}
        |> Map.merge(map_mvt_headers(raw_headers, project_slots))
        |> Map.merge(map_override_headers(raw_headers))
        |> Map.merge(bbc_mvt_complete_header(raw_headers))

      Struct.add(struct, :private, %{mvt: mvt_map})
    else
      struct
    end
  end

  # Takes the raw request headers and the projects slots and
  # makes an 'MVT map'. It iterates from 1 to @max_slots, and:
  #
  # * If the nth MVT slot does not exist then we do not add any thing to the MVT map.
  #
  # * If the nth MVT slot exists and there is no nth bbc MVT raw
  #   request header, then we add the MVT name and index to the MVT map.
  #
  # * If the nth MVT slot exists and there is an nth bbc MVT raw
  #   request header, then we attempt to parse the type, MVT name
  #   and experiment/feature value from the header value.
  #
  #   If the parsed MVT name matches the nth slot MVT name then we add the
  #   MVT name and index with the type and value to the MVT map.
  #
  #   If the parsed MVT name does not match the nth slot MVT name then we add the
  #   MVT name and index to the MVT map.
  defp map_mvt_headers(raw_headers, project_slots) do
    Enum.reduce(1..@max_slots, %{}, fn n, acc ->
      raw_header = raw_headers["bbc-mvt-#{n}"]
      slot_mvt_name = project_slots["bbc-mvt-#{n}"]

      cond do
        slot_mvt_name && !raw_header ->
          put_mvt_name(acc, n, slot_mvt_name)

        slot_mvt_name && raw_header ->
          maybe_update_mvt(acc, n, slot_mvt_name, raw_header)

        true ->
          acc
      end
    end)
  end

  defp maybe_update_mvt(mvt, n, slot_mvt_name, raw_header) do
    case String.split(raw_header, ";", trim: true) do
      [type, header_mvt_name, value] ->
        if slot_mvt_name == header_mvt_name do
          put_mvt_name_type_and_value(mvt, n, header_mvt_name, type, value)
        else
          put_mvt_name(mvt, n, slot_mvt_name)
        end

      _ ->
        mvt
    end
  end

  defp put_mvt_name_type_and_value(mvt, i, header_mvt_name, type, value) do
    Map.put(mvt, "mvt-#{header_mvt_name}", {i, "#{type};#{value}"})
  end

  defp put_mvt_name(mvt, i, header_mvt_name) do
    Map.put(mvt, "mvt-#{header_mvt_name}", {i, nil})
  end

  defp map_override_headers(headers) do
    headers
    |> Enum.filter(fn {name, _v} -> match?(<<"mvt-", _rest::binary>>, name) end)
    |> Enum.into(%{}, fn {name, value} -> {name, {:override, value}} end)
  end

  defp bbc_mvt_complete_header(headers) do
    if headers["bbc-mvt-complete"] in ["0", "1"] do
      v = headers["bbc-mvt-complete"]
      %{"bbc-mvt-complete" => {nil, v}}
    else
      %{}
    end
  end
end
