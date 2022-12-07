defmodule Belfrage.RequestTransformers.ClassicAppFablLdp do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    case struct.request.path_params["guid"] do
      nil ->
        {:ok, struct}

      guid ->
        {:ok,
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
         })}
    end
  end
end
