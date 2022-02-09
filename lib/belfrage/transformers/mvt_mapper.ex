defmodule Belfrage.Transformers.MvtMapper do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    struct = Struct.add(struct, :private, %{mvt: map_mvt_headers(raw_headers)})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct), do: then(rest, struct)

  defp map_mvt_headers(headers) do
    Enum.reduce(1..20, %{}, fn i, mvt ->
      header = Map.get(headers, "bbc-mvt-#{i}")

      if header != nil do
        [type, name, value] = String.split(header, ";")
        value = Enum.join([type, value], ";")
        Map.put(mvt, "mvt-#{name}", {i, value})
      else
        mvt
      end
    end)
  end
end
