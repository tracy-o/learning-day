defmodule Belfrage.Transformers.ClassicAppFablLdp do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    case struct.request.path_params["guid"] do
      nil ->
        then_do(rest, struct)

      guid ->
        then_do(
          rest,
          struct
          |> Struct.add(:request, %{
            path: "/fd/abl-classic",
            path_params: %{
              "name" => "abl-classic"
            },
            query_params: Map.put(struct.request.query_params, "subjectId", guid),
            raw_headers: %{
              "ctx-unwrapped" => "1"
            }
          })
        )
    end
  end
end
