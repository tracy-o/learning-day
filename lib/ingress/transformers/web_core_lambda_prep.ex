defmodule Ingress.Transformers.WebCoreLambdaPrep do
  use Ingress.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{}) do
    struct = put_in(struct.request.payload, web_core_payload(struct))
    then(rest, struct)
  end

  defp web_core_payload(struct) do
    struct.request
    |> Map.take([:path, :payload])
  end
end
