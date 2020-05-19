defmodule Belfrage.Services.Cascade do
  use ExMetrics

  alias Belfrage.Behaviours.Service
  alias Belfrage.{ServiceProvider, Struct}
  require Logger

  @default_response %Struct.Response{http_status: 404, body: ""}

  @behaviour Service

  @impl Service
  def dispatch(structs) do
    structs
    |> Enum.reduce_while(nil, &try_service/2)
  end

  def try_service(struct = %Struct{}, _nothing) do
    Logger.error("Trying service...")
    default_response = Struct.add(struct, :response, @default_response)

    ServiceProvider.service_for(struct.private.origin).dispatch(struct)
    |> maybe_cascade(default_response)
  end

  defp maybe_cascade(%Struct{response: %Struct.Response{http_status: 404}}, default_response) do
    {:cont, default_response}
  end

  defp maybe_cascade(struct, _default_response) do
    {:halt, struct}
  end
end
