defmodule Belfrage.Cascade do
  alias Belfrage.{Struct, ServiceProvider, WrapperError}
  alias Belfrage.Struct.{Response, Private}

  defstruct items: [],
            result: nil

  @type t :: %__MODULE__{
          items: [%Struct{}],
          result: %Struct{} | nil
        }

  def build(struct = %Struct{private: private = %Private{}}) do
    route_state_ids = List.wrap(private.route_state_id)

    %__MODULE__{
      items:
        Enum.map(route_state_ids, fn route_state_id ->
          Struct.add(struct, :private, %{route_state_id: route_state_id, candidate_route_state_ids: route_state_ids})
        end)
    }
  end

  def fan_out(cascade = %__MODULE__{}, callback) do
    metadata = Logger.metadata()

    items =
      cascade.items
      |> Enum.map(fn struct ->
        Task.async(fn ->
          Logger.metadata(metadata)
          callback.(struct)
        end)
      end)
      |> Task.await_many()

    %__MODULE__{cascade | items: items, result: Enum.find(items, &response_available?/1)}
  end

  def result_or(cascade = %__MODULE__{}, callback) do
    if cascade.result do
      cascade.result
    else
      callback.(cascade)
    end
  end

  def dispatch(cascade = %__MODULE__{}, service_provider \\ ServiceProvider) do
    dispatch_to_next_origin(cascade, cascade.items, service_provider)
  end

  defp response_available?(%Struct{response: response = %Response{}}) do
    not is_nil(response.http_status)
  end

  defp dispatch_to_next_origin(cascade, [struct | tail], service_provider) do
    result = WrapperError.wrap(&service_provider.dispatch/1, struct)

    cond do
      use_response?(cascade, result.response) ->
        result

      tail == [] ->
        Struct.add(struct, :response, %Response{http_status: 404, body: ""})

      true ->
        dispatch_to_next_origin(cascade, tail, service_provider)
    end
  end

  def use_response?(%__MODULE__{items: items}, response = %Response{}) do
    response.http_status != 404 || length(items) == 1
  end
end
