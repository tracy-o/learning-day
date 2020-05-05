defmodule Belfrage.Services.Cascade do
  use ExMetrics
  @behaviour Service
  alias Belfrage.Struct

  @default_response %Struct.Response{http_status: 404, body: ""}

  @impl Service
  def dispatch(structs) do
    structs
    |> Enum.reduce_while(@default_response, &try_service/2)
  end

  def try_service(struct = %Struct{}, _default_response) do
    ServiceProvider.service_for(struct.private.origin).dispatch(struct)
    |> maybe_cascade()
  end

  defp maybe_cascade(%Struct{response: %Struct.Response{http_status: 404}}) do
    {:cont, @default_response}
  end

  defp maybe_cascade(struct = %Struct{response: %Struct.Response{http_status: 404}}) do
    {:halt, struct}
  end
end
