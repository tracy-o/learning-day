defmodule Belfrage.Mvt.Headers do
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  # Removes original mvt and override mvt headers from the raw_headers.
  # (mvt headers are in the format 'bbc-mvt-{i}' or 'mvt-*' for override headers).
  #
  # These mvt headers are no longer necessary as they have been mapped into a
  # different form (by Belfrage.Mvt.Mapper) and put into struct.private.mvt.
  def remove_original_headers(struct = %Struct{}) do
    if struct.private.mvt_project_id > 0 do
      filtered_raw_headers =
        :maps.filter(
          fn key, _value -> !String.starts_with?(key, "bbc-mvt-") and !String.starts_with?(key, "mvt-") end,
          struct.request.raw_headers
        )

      put_in(struct.request.raw_headers, filtered_raw_headers)
    else
      struct
    end
  end

  # Maps then puts MVT headers from struct.private.mvt into request headers.
  # If no MVT headers present, request headers returned unchanged.
  def put_mvt_headers(headers, private = %Private{}) do
    if private.mvt == %{} do
      headers
    else
      Enum.reduce(private.mvt, headers, fn {k, {_, v}}, acc ->
        if k != "bbc-mvt-complete" && v do
          Map.put(acc, k, v)
        else
          acc
        end
      end)
    end
  end
end
