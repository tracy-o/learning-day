defmodule Belfrage.ResponseTransformers.MvtMapper do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @impl true
  def call(
        struct = %Struct{
          private: %Struct.Private{mvt: mvt_headers},
          response: %Struct.Response{headers: headers}
        }
      ) do
    vary_header = Map.get(headers, "vary")

    if vary_header && :binary.match(vary_header, "mvt") != :nomatch do
      Struct.add(struct, :private, %{mvt_vary: map_mvt_headers(vary_header, mvt_headers)})
    else
      struct
    end
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
    |> Enum.join(",")
  end
end
