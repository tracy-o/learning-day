defmodule Belfrage.ResponseTransformers.MvtMapper do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @impl true
  def call(
        struct = %Struct{
          private: %Struct.Private{
            headers_allowlist: headers_allowlist,
            mvt: mvt_headers,
            mvt_project_id: mvt_project_id
          },
          response: %Struct.Response{headers: headers}
        }
      )
      when mvt_project_id > 0 do
    vary_header = Map.get(headers, "vary")

    if vary_header && :binary.match(vary_header, "mvt") != :nomatch do
      mapped_mvt_headers = map_mvt_headers(vary_header, mvt_headers)

      Struct.add(struct, :private, %{
        headers_allowlist: filter_mvt_headers(headers_allowlist, mapped_mvt_headers),
        mvt_vary: mapped_mvt_headers
      })
    else
      Struct.add(struct, :private, %{
        headers_allowlist: filter_mvt_headers(headers_allowlist, [])
      })
    end
  end

  @impl true
  def call(struct), do: struct

  defp filter_mvt_headers(headers_allowlist, mapped_mvt_headers) do
    headers_allowlist
    |> Enum.filter(fn header ->
      if String.contains?(header, "mvt-") do
        Enum.member?(mapped_mvt_headers, header)
      else
        header
      end
    end)
  end

  defp map_mvt_headers(vary_header, mvt_headers) do
    test_env? = Application.get_env(:belfrage, :production_environment) == "test"

    vary_header
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn header_name -> String.starts_with?(header_name, "mvt-") end)
    |> Enum.map(fn header_name -> {header_name, Map.get(mvt_headers, header_name)} end)
    |> Enum.map(fn header -> do_header_map(header, test_env?) end)
    |> Enum.reject(&is_nil/1)
  end

  defp do_header_map(header, test_env?) do
    case header do
      {_header_name, {i, _mvt_value}} when is_integer(i) ->
        "bbc-mvt-#{i}"

      {header_name, {i, _mvt_value}} when i == :override and test_env? ->
        header_name

      _ ->
        nil
    end
  end
end
