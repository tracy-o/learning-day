defmodule Belfrage.Cascade do
  alias Belfrage.Struct
  alias Belfrage.Struct.{Response, Private}
  alias Belfrage.ServiceProvider

  def build(struct = %Struct{private: private = %Private{}}) do
    loop_ids = List.wrap(private.loop_id)

    Enum.map(loop_ids, fn loop_id -> Struct.add(struct, :private, %{loop_id: loop_id, candidate_loop_ids: loop_ids}) end)
  end

  def fan_out(cascade, callback) do
    metadata = Stump.metadata() |> Enum.into([])

    cascade =
      cascade
      |> Enum.map(fn struct ->
        fn ->
          Stump.metadata(metadata)
          callback.(struct)
        end
      end)
      |> Enum.map(&Task.async/1)
      |> Enum.map(&Task.await/1)

    Enum.find(cascade, &response_available?/1) || cascade
  end

  def dispatch(cascade, service_provider \\ ServiceProvider) do
    case cascade do
      struct = %Struct{} ->
        struct

      [struct = %Struct{}] ->
        service_provider.dispatch(struct)

      [_ | _] ->
        dispatch_to_cascade(cascade, service_provider)
    end
  end

  defp response_available?(%Struct{response: response = %Response{}}) do
    not is_nil(response.http_status)
  end

  defp dispatch_to_cascade([struct | tail], service_provider) do
    result = service_provider.dispatch(struct)

    cond do
      halt_cascade?(result.response) ->
        result

      tail == [] ->
        Struct.add(struct, :response, %Response{http_status: 404, body: ""})

      true ->
        dispatch_to_cascade(tail, service_provider)
    end
  end

  def halt_cascade?(response = %Response{}) do
    response.http_status != 404
  end
end
