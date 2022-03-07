defmodule Belfrage.Transformers.MvtMapper do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    struct = Struct.add(struct, :private, %{mvt: map_mvt_headers(raw_headers)})

    then_do(rest, struct)
  end

  defp map_mvt_headers(headers) do
    1..20
    |> Enum.filter(fn i -> Map.has_key?(headers, "bbc-mvt-#{i}") end)
    |> Enum.into(%{}, fn i ->
      [type, name, value] = Map.get(headers, "bbc-mvt-#{i}") |> String.split(";")
      {"mvt-#{name}", {i, "#{type};#{value}"}}
    end)
  end
end
