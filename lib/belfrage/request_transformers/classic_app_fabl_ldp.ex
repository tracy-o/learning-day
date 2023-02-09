defmodule Belfrage.RequestTransformers.ClassicAppFablLdp do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    case envelope.request.path_params["guid"] do
      nil ->
        {:ok, envelope}

      guid ->
        {:ok,
         envelope
         |> Envelope.add(:request, %{
           path: "/fd/abl-classic",
           path_params: %{
             "name" => "abl-classic"
           },
           query_params: Map.put(envelope.request.query_params, "subjectId", guid),
           raw_headers: %{
             "ctx-unwrapped" => "1"
           }
         })}
    end
  end
end
