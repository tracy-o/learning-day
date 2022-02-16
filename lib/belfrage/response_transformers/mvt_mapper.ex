defmodule Belfrage.ResponseTransformers.MvtMapper do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @impl true
  def call(
        struct = %Struct{
          private: %Struct.Private{headers_allowlist: headers_allowlist, mvt: mvt_headers},
          response: %Struct.Response{headers: headers}
        }
      ) do
    vary_header = Map.get(headers, "vary")

    if vary_header && :binary.match(vary_header, "mvt") != :nomatch do
      numeric_mvt_headers = map_mvt_headers(vary_header, mvt_headers)

      Struct.add(struct, :private, %{
        headers_allowlist: filter_mvt_headers(headers_allowlist, numeric_mvt_headers),
        mvt_vary: numeric_mvt_headers
      })
    else
      Struct.add(struct, :private, %{
        headers_allowlist: filter_mvt_headers(headers_allowlist, [])
      })
    end
  end

  defp filter_mvt_headers(headers_allowlist, numeric_mvt_headers) do
    headers_allowlist
    |> Enum.filter(fn header ->
      if String.contains?(header, "mvt-") do
        Enum.member?(numeric_mvt_headers, header)
      else
        header
      end
    end)
  end

  defp map_mvt_headers(vary_header, mvt_headers) do
    vary_header
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn header -> String.starts_with?(header, "mvt-") end)
    |> Enum.map(fn header ->
      case Map.get(mvt_headers, header) do
        {i, _} -> "bbc-mvt-#{i}"
        nil -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
